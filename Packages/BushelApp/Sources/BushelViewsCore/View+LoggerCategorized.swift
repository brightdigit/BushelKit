//
// View+LoggerCategorized.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import SwiftData
  import SwiftUI

  extension View where Self: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .view
    }
  }

  extension Scene where Self: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .view
    }
  }

  extension Observable where Self: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .view
    }
  }
#endif
