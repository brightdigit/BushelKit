//
// FileManager.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if os(Linux)
  public typealias FileSize = Int
#else
  public typealias FileSize = Int64
#endif

public extension FileManager {
  struct CreationError: Error {
    enum Source {
      case open
      case ftruncate
      case close
    }

    let code: Int
    let source: Source
  }

  func createFile(atPath path: String, withSize size: FileSize) throws {
    createFile(atPath: path, contents: nil)
    let diskFd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)
    guard diskFd > 0 else {
      throw CreationError(code: Int(errno), source: .open)
    }

    // 64GB disk space.
    var result = ftruncate(diskFd, size)

    guard result == 0 else {
      throw CreationError(code: Int(result), source: .ftruncate)
    }

    result = close(diskFd)
    guard result == 0 else {
      throw CreationError(code: Int(result), source: .close)
    }
  }

  func directoryExists(at url: URL) -> DirectoryExists {
    var isDirectory: ObjCBool = false
    let fileExists = FileManager.default.fileExists(
      atPath: url.path,
      isDirectory: &isDirectory
    )

    return .init(fileExists: fileExists, isDirectory: isDirectory.boolValue)
  }

  @discardableResult
  func createEmptyDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, deleteExistingFile: Bool, attributes _: [FileAttributeKey: Any]? = nil) throws -> DirectoryExists {
    let directoryExistsStatus = self.directoryExists(at: url)

    switch directoryExistsStatus {
    case .directoryExists:
      break

    case .fileExists:
      if deleteExistingFile {
        try FileManager.default.removeItem(at: url)
      }
      fallthrough

    case .notExists:
      try FileManager.default.createDirectory(at: url, withIntermediateDirectories: createIntermediates)
    }

    return directoryExistsStatus
  }
}
