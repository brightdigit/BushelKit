//
// BushelFeedbackCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFeedbackCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelEnvironmentCore()
    Sentry()
  }
}
