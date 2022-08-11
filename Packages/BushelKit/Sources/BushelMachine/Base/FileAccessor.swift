//
// FileAccessor.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/8/22.
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
