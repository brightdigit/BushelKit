//
// LoggerCategorized.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

public protocol LoggerCategorized {
  static var loggingCategory: LoggerCategory {
    get
  }
}

public extension LoggerCategorized {
  static var logger: Logger {
    Logger.forCategory(loggingCategory)
  }
}
