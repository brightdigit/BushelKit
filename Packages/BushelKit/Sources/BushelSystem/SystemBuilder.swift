//
// SystemBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

@resultBuilder
public enum SystemBuilder {
  public static func buildBlock(_ components: System...) -> [System] {
    components
  }

  public static func buildPartialBlock(first: System) -> [System] {
    [first]
  }

  public static func buildPartialBlock(accumulated: [System], next: System) -> [System] {
    accumulated + [next]
  }
}
