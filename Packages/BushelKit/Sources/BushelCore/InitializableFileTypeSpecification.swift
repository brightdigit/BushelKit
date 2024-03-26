//
// InitializableFileTypeSpecification.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol InitializableFileTypeSpecification: FileTypeSpecification {
  associatedtype WindowValueType: Codable & Hashable
  static func createAt(_ url: URL) throws -> WindowValueType
}
