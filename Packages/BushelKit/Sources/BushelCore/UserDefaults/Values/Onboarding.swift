//
// Onboarding.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum Onboarding {
  public enum Beta: AppStored {
    public static let keyType: KeyType = .reflecting
    public typealias Value = Date?
  }

  @available(*, unavailable, message: "Not ready for release.")
  public enum NorthernSpy: AppStored {
    public static let keyType: KeyType = .reflecting
    public typealias Value = Date?
  }
}
