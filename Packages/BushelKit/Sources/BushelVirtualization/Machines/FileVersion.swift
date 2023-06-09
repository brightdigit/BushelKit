//
// FileVersion.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol FileVersion {
  static var typeID: String { get }
  var url: URL { get }
  var isDiscardable: Bool { get }
  var modificationDate: Date? { get }

  static func fetchVersion(at url: URL, withID id: Data) throws -> FileVersion?
  static func createVersion(at url: URL, withContentsOf contentsURL: URL, isDiscardable: Bool, byMoving: Bool) throws -> FileVersion

  func save(to url: URL) async throws
  func getIdentifier() throws -> Data
}

public extension FileVersion {
  static func createVersion(at url: URL, withContentsOf contentsURL: URL, isDiscardable: Bool = false) throws -> FileVersion {
    try createVersion(at: url, withContentsOf: contentsURL, isDiscardable: isDiscardable, byMoving: false)
  }
}
