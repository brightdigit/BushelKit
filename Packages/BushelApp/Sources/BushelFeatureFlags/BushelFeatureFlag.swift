//
// BushelFeatureFlag.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import FeatherQuill
  import SwiftUI

  public protocol BushelFeatureFlag: FeatureFlag {}

  extension BushelFeatureFlag {
    public static func evaluateUser(_ userType: UserAudience) async -> Bool {
      await UserEvaluator.evaluate(userType)
    }
  }
#endif
