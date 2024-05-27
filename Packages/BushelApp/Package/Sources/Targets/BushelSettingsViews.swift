//
// BushelSettingsViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelSettingsViews: Target {
  var dependencies: any Dependencies {
    BushelData()
    BushelLocalization()
    BushelMarketEnvironment()
    BushelOnboardingEnvironment()
    BushelFeatureFlags()
    BushelFeedbackEnvironment()
  }
}
