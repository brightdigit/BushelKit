//
// LoggerCategorized.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

@available(*, deprecated, message: "Use FelinePine Package.")
public protocol LoggerCategorized: Loggable {
  static var loggingCategory: LoggerCategory {
    get
  }
}

@available(*, deprecated, message: "Use FelinePine Package.")
public extension LoggerCategorized {
  static var logger: Logger {
    Logger.forCategory(loggingCategory)
  }
}
