//
// Scene+OnboardingWindow.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelEnvironmentCore

  public import BushelOnboardingCore
  import Foundation
  import RadiantKit

  public import SwiftUI

  private struct OnboardingWindowValueKey: EnvironmentKey {
    typealias Value = OnboardingWindowValue
  }

  extension EnvironmentValues {
    public var onboardingWindow: OnboardingWindowValue {
      get { self[OnboardingWindowValueKey.self] }
      set { self[OnboardingWindowValueKey.self] = newValue }
    }
  }

  extension Scene {
    public func onboardingWindow(
      _ value: OnboardingWindowValue
    ) -> some Scene {
      self.environment(\.onboardingWindow, value)
    }
  }
#endif
