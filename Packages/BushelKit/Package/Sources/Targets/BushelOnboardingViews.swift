//
// BushelOnboardingViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelOnboardingViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelLocalization()
    BushelViewsCore()
    RadiantKit()
    BushelOnboardingCore()
  }
}
