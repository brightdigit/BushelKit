//
// RestoreImageLibraryExtraction.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct RestoreImageLibraryExtraction: DocumentContextual {
  public static var type: BushelMachine.DocumentURL.DocumentType {
    .library
  }

  public let context: RestoreImageLibraryContext
  let library: RestoreImageLibrary

  public init(loadFrom url: URL) throws {
    library = try RestoreImageLibrary(loadFrom: url)
    context = RestoreImageLibraryContext(url: url)
  }

  public static func fromURL(_ url: URL) throws -> RestoreImageLibraryExtraction {
    try .init(loadFrom: url)
  }
}

public extension RestoreImageLibraryExtraction {
  var imageConexts: [RestoreImageContext] {
    library.items.map { file in
      RestoreImageContext(library: self.context, file: file)
    }
  }
}
