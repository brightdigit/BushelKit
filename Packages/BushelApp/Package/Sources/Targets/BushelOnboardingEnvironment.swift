//
// BushelOnboardingEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelOnboardingEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelEnvironmentCore()
    BushelOnboardingCore()
    RadiantKit()
  }
}
