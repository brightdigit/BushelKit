//
// Logger.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

extension Logger {
  // swiftlint:disable:next force_unwrapping
  static let subsystem: String = Bundle.main.bundleIdentifier!

  init(category: LoggerCategory) {
    #if canImport(os)
      self.init(subsystem: Self.subsystem, category: category.rawValue)
    #else
      self.init(label: Self.subsystem)
      self[metadataKey: "category"] = "\(category)"
    #endif
  }

  private static let loggers: [LoggerCategory: Logger] = .init(
    uniqueKeysWithValues: LoggerCategory.allCases.map {
      ($0, Logger(category: $0))
    }
  )

  public static func forCategory(_ category: LoggerCategory) -> Logger {
    guard let logger = Self.loggers[category] else {
      preconditionFailure("missing logger")
    }
    return logger
  }
}
