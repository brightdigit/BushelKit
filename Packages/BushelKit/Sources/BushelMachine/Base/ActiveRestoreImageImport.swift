//
// ActiveRestoreImageImport.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import Foundation

public struct ActiveRestoreImageImport: Identifiable {
  public init(sourceURL: URL) {
    self.sourceURL = sourceURL
  }

  public let sourceURL: URL

  public var id: URL {
    sourceURL
  }
}
