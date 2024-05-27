//
// Analytics.swift
// Copyright (c) 2024 BrightDigit.
//

import AviaryInsights
import BushelCore
import Foundation

public struct StartupEvent: Event {
  public init() {}
  public func plausibleEvent() -> AviaryInsights.Event {
    AviaryInsights.Event(url: "bushel://startup")
  }
}

public protocol Event {
  func plausibleEvent() -> AviaryInsights.Event
}

public class PlausibleAnalytics: Analytics {
  // swiftlint:disable:next force_unwrapping
  private let client = Plausible(defaultDomain: "macos.\(Bundle.main.bundleIdentifier!)".lowercased())
  public init() {}

  public func sendEvent(_ event: any Event) {
    if UserDefaults.standard.value(for: Tracking.Analytics.self) {
      client.postEvent(event.plausibleEvent())
    }
  }
}

public protocol Analytics {
  func sendEvent(_ event: any Event)
}
