//
// FileManager+ReduceDirectory.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

private actor FileManagerActor {
  struct SendableBox: @unchecked Sendable {
    let value: FileManager

    init(_ value: FileManager) {
      self.value = value
    }
  }

  let fileManager: FileManager

  init(fileManager: @Sendable @autoclosure () -> SendableBox) {
    self.fileManager = fileManager().value
  }

  #warning("logging-note: not sure what to log here")
  func reduce<T: Sendable>(
    _ keys: [URLResourceKey],
    directoryAt url: URL,
    fromValues valuesFrom: @Sendable @escaping (URLResourceValues) -> T,
    initial: T,
    nextPartialResult: @Sendable @escaping (T, T) -> T
  ) async throws -> T {
    let allKeys: Set<URLResourceKey> = Set([.isDirectoryKey, .isRegularFileKey] + keys)

    guard let enumerator = self.fileManager.enumerator(
      at: url,
      includingPropertiesForKeys: Array(allKeys)
    ) else {
      throw .fileNotFound(at: url)
    }

    return try await withThrowingTaskGroup(of: T.self) { taskGroup in
      for case let url as URL in enumerator {
        taskGroup.addTask {
          try await Task {
            let values = try url.resourceValues(forKeys: allKeys)
            if values.isDirectory == true {
              return try await self.reduce(
                keys,
                directoryAt: url,
                fromValues: valuesFrom,
                initial: initial,
                nextPartialResult: nextPartialResult
              )
            } else {
              return valuesFrom(values)
            }
          }.value
        }
      }
      return try await taskGroup.reduce(initial, nextPartialResult)
    }
  }
}

public extension FileManager {
  func reduce<T: Sendable>(
    _ key: URLResourceKey,
    directoryAt url: URL,
    _ initial: T,
    _ nextPartialResult: @escaping @Sendable (T, T) -> T
  ) async throws -> T {
    try await self.reduce(
      [key],
      directoryAt: url,
      // swiftlint:disable:next force_cast
      fromValues: { $0.allValues[key] as! T },
      initial,
      nextPartialResult
    )
  }

  func reduce<T: Sendable>(
    _ keys: [URLResourceKey],
    directoryAt url: URL,
    fromValues valuesFrom: @escaping @Sendable (URLResourceValues) -> T,
    _ initial: T,
    _ nextPartialResult: @escaping @Sendable (T, T) -> T
  ) async throws -> T {
    let box = FileManagerActor.SendableBox(self)
    return try await FileManagerActor(fileManager: box)
      .reduce(
        keys,
        directoryAt: url,
        fromValues: valuesFrom,
        initial: initial,
        nextPartialResult: nextPartialResult
      )
  }

  func accumulateSizeFromDirectory(at url: URL) async throws -> Int {
    try await self.reduce(.totalFileAllocatedSizeKey, directoryAt: url, 0) {
      $0 + $1
    }
  }
}
