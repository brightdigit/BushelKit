//
// BushelCanary.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelCanary: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    Sentry()
  }
}
