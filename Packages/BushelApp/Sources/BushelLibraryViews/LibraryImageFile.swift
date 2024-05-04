//
// LibraryImageFile.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLibrary
import Foundation

extension LibraryImageFile {
  init(
    request: ImportRequest,
    using system: any LibrarySystem
  ) async throws {
    switch request {
    case let .local(url: importingURL):
      do {
        self = try await system.restoreImageLibraryItemFile(fromURL: importingURL)
      } catch {
        throw LibraryError.imageCorruptedError(error, at: importingURL)
      }

    case .remote(url: _, metadata: let metadata):
      self.init(metadata: metadata, name: system.label(fromMetadata: metadata).defaultName)
    }
  }
}
