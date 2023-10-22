//
// BushelOnboardingEnvironment.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelOnboardingEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelEnvironmentCore()
    BushelOnboardingCore()
  }
}
