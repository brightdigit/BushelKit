//
// BushelViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelViews: Target {
  var dependencies: any Dependencies {
    BushelLibraryViews()
    BushelMachineViews()
    BushelSettingsViews()
    BushelWelcomeViews()
    BushelHubViews()
    BushelMarketViews()
    BushelOnboardingViews()
  }
}
