//
// UserDefaults.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import FelinePine
import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

extension UserDefaults {
  func decode<T: UserDefaultsCodable, LoggableType: Loggable>(
    from _: LoggableType.Type,
    override: [T]? = nil,
    defaultValue: [T] = .init()
  ) -> [T] {
    decode(
      using: Configuration.Defaults.decoder,
      withKey: T.key,
      logger: LoggableType.logger,
      override: override,
      defaultValue: defaultValue
    )
  }
}
