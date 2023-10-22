//
// BushelOnboardingViews.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelOnboardingViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelLocalization()
    BushelViewsCore()
    BushelOnboardingCore()
  }
}
