//
// Canary.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Sentry)
  import BushelCore

  import Foundation
  import Sentry

  public enum Canary {
    public static func setupErrorTracking() {
      let configuration = SentryConfiguration.main
      assert(configuration != nil)
      if let configuration, UserDefaults.standard.bool(forKey: Tracking.Error.key, defaultValue: true) {
        SentrySDK.start { options in
          options.dsn = configuration.dsn
          // options.debug = true // Enabling debug when first installing is always helpful

          // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
          // We recommend adjusting this value in production.
          // options.tracesSampleRate = 1.0

          // Sample rate for profiling, applied on top of TracesSampleRate.
          // We recommend adjusting this value in production.
          // options.profilesSampleRate = 1.0
        }
      }
    }
  }
#endif
