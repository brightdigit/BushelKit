//
// ActiveRestoreImageImport.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct ActiveRestoreImageImport: Identifiable {
  public init(sourceURL: URL) {
    self.sourceURL = sourceURL
  }

  public let sourceURL: URL

  public var id: URL {
    sourceURL
  }
}
