//
// VersionEvaluator.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

internal struct VersionEvaluator: UserEvaluatorComponent {
  static let evaluatingValue: BushelCore.UserAudience = .testFlightBeta

  func evaluate(_: BushelCore.UserAudience) -> Bool {
    assert(Bundle.main.version != nil)
    guard let version = Bundle.main.version else {
      return false
    }
    return version.prereleaseLabel != nil
  }
}
