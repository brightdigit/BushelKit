//
// BlankFileDocument.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers

  protocol BlankFileDocument {
    static var allowedContentTypes: [UTType] { get }
    static func saveBlankDocumentAt(_ url: URL) throws
  }
#endif
