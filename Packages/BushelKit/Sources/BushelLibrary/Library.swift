//
// Library.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct Library: Codable, Equatable {
  public var items: [LibraryImageFile]
  public init(items: [LibraryImageFile] = .init()) {
    self.items = items
  }
}
