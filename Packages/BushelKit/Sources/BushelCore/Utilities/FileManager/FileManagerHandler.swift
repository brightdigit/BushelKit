//
// FileManagerHandler.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public actor FileManagerHandler: FileHandler {
  let fileManager: @Sendable () -> FileManager

  public init(fileManager: @Sendable @escaping () -> FileManager) {
    self.fileManager = fileManager
  }

  public func attributesAt(_ url: URL) async throws -> any AttributeSet {
    #if canImport(FoundationNetworking)
      let dictionary = try self.fileManager().attributesOfItem(atPath: url.path)
    #else
      let dictionary = try self.fileManager().attributesOfItem(atPath: url.path(percentEncoded: false))
    #endif
    return DictionaryAttributeSet(dictionary: dictionary)
  }

  public func copy(at fromURL: URL, to toURL: URL) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      do {
        try self.fileManager().copyItem(at: fromURL, to: toURL)
      } catch {
        // self.logger?.error("Error Copying: \(error)")
        // self.killTimer()
        continuation.resume(throwing: error)
        return
      }
      // self.logger?.debug("Copy is done. Quitting timer.")
      // self.killTimer()

      continuation.resume(returning: ())
    }
  }
}
