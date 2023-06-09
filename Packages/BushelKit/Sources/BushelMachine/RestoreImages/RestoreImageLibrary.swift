//
// RestoreImageLibrary.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public struct RestoreImageLibrary: Codable {
  public var items: [RestoreImageLibraryItemFile]
  public init(items: [RestoreImageLibraryItemFile] = .init()) {
    self.items = items
  }
}

public extension RestoreImageLibrary {
  init(loadFrom url: URL) throws {
    let data = try Data(contentsOf: url.appendingPathComponent(Paths.restoreLibraryJSONFileName))
    self = try JSON.tryDecoding(data)
  }
}
