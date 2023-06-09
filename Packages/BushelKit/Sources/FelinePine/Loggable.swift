//
// Loggable.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

@available(*, deprecated, message: "Use FelinePine Package.")
public protocol Loggable {
  static var logger: Logger {
    get
  }
}
