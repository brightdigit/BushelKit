//
// SentryConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct SentryConfiguration: Sendable {
  enum Keys: String {
    case sentry = "Sentry"
    case dsn = "DSN"
  }

  public static let main: SentryConfiguration? = .init()
  public let dsn: String
}

extension SentryConfiguration {
  public init?(bundle: Bundle = .main) {
    guard let dictionary = bundle.object(
      forInfoDictionaryKey: Keys.sentry.rawValue
    ) as? [String: String] else {
      return nil
    }

    guard let dsn = dictionary[Keys.dsn.rawValue] else {
      return nil
    }

    self.init(dsn: dsn)
  }
}
