//
// LaunchOptions.swift
// Copyright (c) 2023 BrightDigit.
//

public struct LaunchOptions: OptionSet {
  public typealias RawValue = Int

  public static let resetApplication: Self = .init(rawValue: 1)
  public let rawValue: Int
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}
