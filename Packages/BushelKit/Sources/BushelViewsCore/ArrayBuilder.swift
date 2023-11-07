//
// ArrayBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

@resultBuilder
public enum ArrayBuilder<Item> {
  public static func buildPartialBlock(first: Item) -> [Item] {
    [first]
  }

  public static func buildPartialBlock(accumulated: [Item], next: Item) -> [Item] {
    accumulated + [next]
  }
}
