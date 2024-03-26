//
// SnapshotOptions.swift
// Copyright (c) 2024 BrightDigit.
//

public struct SnapshotOptions: OptionSet {
  public typealias RawValue = Int

  public static let discardable: SnapshotOptions = .init(rawValue: 1)

  public static let byMoving: SnapshotOptions = .init(rawValue: 2)

  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}
