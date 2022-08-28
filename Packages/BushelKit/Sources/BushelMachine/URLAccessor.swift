//
// URLAccessor.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import SwiftUI
import UniformTypeIdentifiers

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
