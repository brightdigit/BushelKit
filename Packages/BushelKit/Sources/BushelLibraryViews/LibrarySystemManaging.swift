//
// LibrarySystemManaging.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(UniformTypeIdentifiers)
  import BushelLibrary
  import BushelUT
  import Foundation
  import UniformTypeIdentifiers

  extension LibrarySystemManaging {
    var allAllowedContentTypes: [UTType] {
      self.allAllowedFileTypes.map(UTType.init(fileType:))
    }
  }
#endif
