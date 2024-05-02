//
// FileTypeSpecification.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol FileTypeSpecification: Sendable {
  static var fileType: FileType { get }
}
