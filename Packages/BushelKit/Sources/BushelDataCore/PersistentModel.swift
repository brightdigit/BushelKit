//
// PersistentModel.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelLogging
  import Foundation
  import SwiftData

  public extension PersistentModel where Self: LoggerCategorized {
    static var loggingCategory: BushelLogging.Loggers.Category {
      .data
    }

    typealias LoggersType = BushelLogging.Loggers
  }
#endif
