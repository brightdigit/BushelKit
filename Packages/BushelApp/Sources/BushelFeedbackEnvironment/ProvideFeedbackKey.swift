//
// ProvideFeedbackKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore
  import BushelEnvironmentCore
  import Foundation
  import SwiftData

  public import SwiftUI

  public struct ProvideFeedbackWindowValue: DefaultableViewValue {
    public static let `default` = ProvideFeedbackWindowValue()

    private init() {}
  }

  private struct ProvideFeedbackKey: EnvironmentKey {
    typealias Value = ProvideFeedbackWindowValue
  }

  extension EnvironmentValues {
    public var provideFeedback: ProvideFeedbackWindowValue {
      get { self[ProvideFeedbackKey.self] }
      set { self[ProvideFeedbackKey.self] = newValue }
    }
  }

#endif
