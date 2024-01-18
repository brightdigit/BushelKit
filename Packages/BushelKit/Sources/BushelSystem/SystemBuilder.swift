//
// SystemBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine

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

  public static func buildPartialBlock(first: @escaping () -> [Hub]) -> [System] {
    [CompsositeSystem(hubsClosure: first)]
  }

  public static func buildPartialBlock(accumulated: [System], next: @escaping () -> [Hub]) -> [System] {
    accumulated + [CompsositeSystem(hubsClosure: next)]
  }
}
