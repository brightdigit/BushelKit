//
// FileManager.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers

  public extension FileManager {
    func createTemporaryFile(for source: UTType) -> URL {
      let tempFile: URL
      tempFile = temporaryDirectory
        .appending(path: UUID().uuidString)
        .appendingPathExtension(for: source)
      return tempFile
    }
  }
#endif
