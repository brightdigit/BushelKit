//
// View+LoggerCategorized.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import SwiftData
  import SwiftUI

  public extension View where Self: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .view
    }
  }

  public extension Scene where Self: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .view
    }
  }

  public extension Observable where Self: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .view
    }
  }
#endif
