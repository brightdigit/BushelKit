//
// View+LoggerCategorized.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import SwiftData
  import SwiftUI

  public extension View where Self: LoggerCategorized {
    static var loggingCategory: BushelLogging.Loggers.Category {
      .view
    }
  }

  public extension Scene where Self: LoggerCategorized {
    static var loggingCategory: BushelLogging.Loggers.Category {
      .view
    }
  }

  public extension Observable where Self: LoggerCategorized {
    static var loggingCategory: BushelLogging.Loggers.Category {
      .view
    }
  }
#endif
