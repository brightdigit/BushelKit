//
// URLAccessor.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import SwiftUI
import UniformTypeIdentifiers

public struct URLAccessor: FileAccessor {
  public init(url: URL, sha256: SHA256? = nil) {
    self.url = url
    self.sha256 = sha256
  }

  let url: URL
  public let sha256: BushelMachine.SHA256?

  public func getData() -> Data? {
    nil
  }

  public func getURL(createIfNotExists _: Bool) throws -> URL {
    url
  }

  public func updatingWithURL(_ url: URL, sha256: SHA256?) -> BushelMachine.FileAccessor {
    URLAccessor(url: url, sha256: sha256)
  }
}
