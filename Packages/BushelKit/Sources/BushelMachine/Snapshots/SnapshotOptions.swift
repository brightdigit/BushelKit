//
// SnapshotOptions.swift
// Copyright (c) 2023 BrightDigit.
//

public struct SnapshotOptions: OptionSet {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  public let rawValue: Int

  public typealias RawValue = Int

  public static let discardable: SnapshotOptions = .init(rawValue: 1)

  public static let byMoving: SnapshotOptions = .init(rawValue: 2)
}
