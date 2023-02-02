//
// URLAccessor.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct URLAccessor: FileAccessor {
  public init(url: URL) {
    self.url = url
  }

  let url: URL

  public func getData() -> Data? {
    nil
  }

  public func getURL(createIfNotExists _: Bool) throws -> URL {
    url
  }

  public func updatingWithURL(_ url: URL) -> BushelMachine.FileAccessor {
    URLAccessor(url: url)
  }
}
