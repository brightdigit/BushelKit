//
// FileAccessor.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol FileAccessor {
  func getData() -> Data?
  func getURL(createIfNotExists: Bool) throws -> URL
  func updatingWithURL(_ url: URL) -> FileAccessor
}

public extension FileAccessor {
  func getURL() throws -> URL {
    try getURL(createIfNotExists: true)
  }
}
