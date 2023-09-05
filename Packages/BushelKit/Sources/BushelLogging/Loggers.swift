//
// Loggers.swift
// Copyright (c) 2023 BrightDigit.
//

import FelinePine

#if canImport(os)
  import os
#elseif canImport(Logging)
  import Logging
#endif

public protocol LoggerCategorized: FelinePine.LoggerCategorized where LoggersType == Loggers {}

public enum Loggers: FelinePine.Loggers {
  public static let loggers: [Category: Logger] = Self._loggers

  public enum Category: String, CaseIterable {
    case library
    case data
    case view
    case machine
    case application
    case observation
  }

  public typealias LoggerCategory = Category
}
