//
// BushelFeedbackEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFeedbackEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelEnvironmentCore()
  }
}
