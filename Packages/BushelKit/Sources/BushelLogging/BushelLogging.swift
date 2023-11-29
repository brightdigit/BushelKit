//
// BushelLogging.swift
// Copyright (c) 2023 BrightDigit.
//

import FelinePine

public enum BushelLogging: LoggingSystem {
  public enum Category: String, CaseIterable {
    case library
    case data
    case view
    case machine
    case application
    case observation
    case market
  }
}
