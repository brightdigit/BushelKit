//
// AppStored.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct RecentDocumentsClearDate: AppStored {
  public typealias Value = Date?
}

public struct OnboardingAlphaAt: AppStored {
  public typealias Value = Date?
}

@available(*, unavailable, message: "Not ready for release.")
public struct OnboardingV1At: AppStored {
  public typealias Value = Date?
}

public protocol AppStored {
  associatedtype Value
  static var key: String { get }
}

public extension AppStored {
  static var key: String {
    "\(Self.self)"
  }
}
