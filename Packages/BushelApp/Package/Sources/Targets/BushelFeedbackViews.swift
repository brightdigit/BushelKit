//
// BushelFeedbackViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFeedbackViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelViewsCore()
    BushelFeedbackCore()
  }
}
