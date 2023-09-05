//
// CodablePackage.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol CodablePackage: Codable {
  static var decoder: JSONDecoder { get }
  static var encoder: JSONEncoder { get }
  static var configurationFileWrapperKey: String { get }
  static var readableContentTypes: [FileType] { get }
}

public extension CodablePackage {
  init(contentsOf url: URL) throws {
    let data = try Data(contentsOf: url.appendingPathComponent(Self.configurationFileWrapperKey))
    self = try Self.decoder.decode(Self.self, from: data)
  }
}
