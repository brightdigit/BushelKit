//
// Scene+OnboardingWindow.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelEnvironmentCore
  import BushelOnboardingCore
  import Foundation
  import SwiftUI

  private struct OnboardingWindowValueKey: EnvironmentKey {
    typealias Value = OnboardingWindowValue
  }

  public extension EnvironmentValues {
    var onboardingWindow: OnboardingWindowValue {
      get { self[OnboardingWindowValueKey.self] }
      set { self[OnboardingWindowValueKey.self] = newValue }
    }
  }

  public extension Scene {
    func onboardingWindow(
      _ value: OnboardingWindowValue
    ) -> some Scene {
      self.environment(\.onboardingWindow, value)
    }
  }
#endif
