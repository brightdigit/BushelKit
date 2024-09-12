//
// UserFeedback.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore

  public import FeatherQuill

  public import SwiftUI

  public struct UserFeedback: BushelFeatureFlag {
    public typealias UserTypeValue = UserAudience

    public static let probability: Double = 0.25
    public static let initialValue = false
  }

  extension EnvironmentValues {
    public var userFeedback: UserFeedback.Feature { self[UserFeedback.self] }
  }
#endif
