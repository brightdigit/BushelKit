//
// FileAccessor.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

@available(*, deprecated, message: "Can we use a generic here instead.")
public protocol FileAccessor {
  func getURL(createIfNotExists: Bool) throws -> URL
  func updatingWithURL(_ url: URL) -> FileAccessor
}

public extension FileAccessor {
  func getURL() throws -> URL {
    try getURL(createIfNotExists: true)
  }
}
