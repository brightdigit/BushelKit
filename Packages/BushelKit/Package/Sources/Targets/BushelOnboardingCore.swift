//
// BushelOnboardingCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelOnboardingCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
