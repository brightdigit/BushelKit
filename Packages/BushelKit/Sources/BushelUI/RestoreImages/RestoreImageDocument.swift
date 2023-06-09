//
// RestoreImageDocument.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
  import Foundation
  import SwiftUI
  import UniformTypeIdentifiers

  struct RestoreImageDocument: FileDocument {
    static let readableContentTypes = UTType.ipswTypes
    let fileWrapper: FileWrapper

    init(configuration: ReadConfiguration) throws {
      fileWrapper = configuration.file
      ApplicationContext.shared.refreshRecentDocuments()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
      guard let fileWrapper = configuration.existingFile else {
        throw DocumentError.undefinedType(
          "Missing file for restore image.",
          configuration.existingFile
        )
      }

      return fileWrapper
    }
  }
#endif
