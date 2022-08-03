//
// URLAccessor.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import SwiftUI
import UniformTypeIdentifiers

import BushelMachine

struct URLAccessor: FileAccessor {
  let url: URL
  let sha256: BushelMachine.SHA256?

  func getData() -> Data? {
    nil
  }

  func getURL() throws -> URL {
    url
  }

  func updatingWithURL(_ url: URL, sha256: BushelMachine.SHA256) -> BushelMachine.FileAccessor {
    URLAccessor(url: url, sha256: sha256)
  }
}
