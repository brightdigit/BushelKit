//
// BushelAnalyticsEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelAnalyticsEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()

    BushelAnalyticsCore()
  }
}
