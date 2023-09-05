//
// InitializableFileTypeSpecification.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol InitializableFileTypeSpecification: FileTypeSpecification {
  associatedtype WindowValueType: Codable & Hashable
  static func createAt(_ url: URL) throws -> WindowValueType
}
