//
// SystemBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelHub
import BushelLibrary
import BushelMachine

@resultBuilder
public enum SystemBuilder {
  public static func buildBlock(_ components: any System...) -> [any System] {
    components
  }

  public static func buildPartialBlock(first: any System) -> [any System] {
    [first]
  }

  public static func buildPartialBlock(
    accumulated: [any System],
    next: any System
  ) -> [any System] {
    accumulated + [next]
  }

  public static func buildPartialBlock(first: @escaping @Sendable () -> [Hub]) -> [any System] {
    [CompsositeSystem(hubsClosure: first)]
  }

  public static func buildPartialBlock(
    accumulated: [any System],
    next: @escaping @Sendable () -> [Hub]
  ) -> [any System] {
    accumulated + [CompsositeSystem(hubsClosure: next)]
  }
}
