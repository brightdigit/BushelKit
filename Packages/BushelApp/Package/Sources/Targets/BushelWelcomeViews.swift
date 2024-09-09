//
// BushelWelcomeViews.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelWelcomeViews: Target {
  var dependencies: any Dependencies {
    BushelData()
    BushelLocalization()
    BushelOnboardingEnvironment()
    BushelMarketEnvironment()
    BushelMessage()
    BushelSessionEnvironment()
    BushelAccessibility()
    BushelFeedbackEnvironment()
    BushelWishListEnvironment()
    DataThespian()
  }
}
