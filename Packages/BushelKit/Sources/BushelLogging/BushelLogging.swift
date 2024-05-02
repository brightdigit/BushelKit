//
// BushelLogging.swift
// Copyright (c) 2024 BrightDigit.
//

import FelinePine

public enum BushelLogging: LoggingSystem, Sendable {
  public enum Category: String, CaseIterable, Sendable {
    case library
    case data
    case view
    case machine
    case application
    case observation
    case market
    case hub
  }
}
