//
// UTType.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers

  public extension UTType {
    init(fileType: FileType) {
      if fileType.isOwned {
        self.init(exportedAs: fileType.utIdentifier)
      } else {
        // swiftlint:disable:next force_unwrapping
        self.init(fileType.utIdentifier)!
      }
    }

    static func allowedContentTypes(for fileType: FileType) -> [UTType] {
      var types = [UTType]()

      if fileType.isOwned {
        types.append(.init(exportedAs: fileType.utIdentifier))
      }

      if let fileExtensionType = fileType.fileExtension.flatMap({ UTType(filenameExtension: $0) }) {
        types.append(fileExtensionType)
      }

      if let utIdentified = UTType(fileType.utIdentifier) {
        types.append(utIdentified)
      }

      return types
    }

    static func allowedContentTypes(for fileTypes: FileType ...) -> [UTType] {
      fileTypes.flatMap(Self.allowedContentTypes(for:))
    }
  }

  public extension FileType {
    init?(url: URL) {
      guard let utType = UTType(filenameExtension: url.pathExtension) else {
        return nil
      }
      self.init(stringLiteral: utType.identifier)
    }
  }
#endif
