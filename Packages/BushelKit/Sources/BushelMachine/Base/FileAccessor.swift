//
// FileAccessor.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Foundation

public protocol FileAccessor {
  var sha256: SHA256? { get }
  func getData() -> Data?
  func getURL(createIfNotExists: Bool) throws -> URL
  func updatingWithURL(_ url: URL, sha256: SHA256?) -> FileAccessor
}

public extension FileAccessor {
  func getURL() throws -> URL {
    try getURL(createIfNotExists: true)
  }
}
