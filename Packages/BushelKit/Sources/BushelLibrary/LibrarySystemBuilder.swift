//
// LibrarySystemBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

@resultBuilder
public enum LibrarySystemBuilder {
  public static func buildBlock(_ components: any LibrarySystem ...) -> [any LibrarySystem] {
    components
  }
}
