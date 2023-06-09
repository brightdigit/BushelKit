//
// URLAccessor.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct URLAccessor: FileAccessor {
  let url: URL
  public init(url: URL) {
    self.url = url
  }

  public func getURL(createIfNotExists _: Bool) throws -> URL {
    url
  }

  public func updatingWithURL(_ url: URL) -> FileAccessor {
    URLAccessor(url: url)
  }
}
