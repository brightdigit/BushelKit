//
// Analytics.swift
// Copyright (c) 2024 BrightDigit.
//

import AviaryInsights

public protocol Event {
  func plausibleEvent() -> AviaryInsights.Event
}

public class PlausibleAnalytics: Analytics {
  private let client = Plausible(defaultDomain: "macos.com.brightdigit.bushel")
  public func sendEvent(_ event: any Event) {
    client.postEvent(event.plausibleEvent())
  }
}

public protocol Analytics {
  func sendEvent(_ event: any Event)
}
