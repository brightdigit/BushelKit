//
// RestoreImageLibrary.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct RestoreImageLibrary: Codable {
  public init(items: [RestoreImageLibraryItemFile] = .init()) {
    self.items = items
  }

  public var items: [RestoreImageLibraryItemFile]
}

public extension RestoreImageLibrary {
  init(loadFrom url: URL) throws {
    let data = try Data(contentsOf: url.appendingPathComponent(Paths.restoreLibraryJSONFileName))
    self = try JSON.tryDecoding(data)
  }
}
