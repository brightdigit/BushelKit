//
// StateAction.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct StateAction: OptionSet {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  public let rawValue: Int

  public typealias RawValue = Int

  public static let start = Self(rawValue: 1 << 0)
  public static let stop = Self(rawValue: 1 << 1)
  public static let pause = Self(rawValue: 1 << 2)
  public static let resume = Self(rawValue: 1 << 3)
  public static let requestStop = Self(rawValue: 1 << 4)
}
