//
// BushelOnboardingCore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelOnboardingCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
