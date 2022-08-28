//
// RestoreImageLibrary.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

public struct RestoreImageLibrary: Codable {
  public init(items: [RestoreImageLibraryItemFile] = .init()) {
    self.items = items
  }

  public var items: [RestoreImageLibraryItemFile]
}
