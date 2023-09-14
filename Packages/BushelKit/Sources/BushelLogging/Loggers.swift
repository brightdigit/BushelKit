//
// Loggers.swift
// Copyright (c) 2023 BrightDigit.
//

import FelinePine

public protocol LoggerCategorized: FelinePine.LoggerCategorized where LoggersType == Loggers {}

public enum Loggers: FelinePine.Loggers {
  public typealias LoggerCategory = Category

  public enum Category: String, CaseIterable {
    case library
    case data
    case view
    case machine
    case application
    case observation
    case market
  }

  public static let loggers: [Category: Logger] = Self._loggers
}
