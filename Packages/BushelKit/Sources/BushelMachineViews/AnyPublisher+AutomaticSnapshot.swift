//
// AnyPublisher+AutomaticSnapshot.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Combine)
  import BushelLogging
  import Combine
  import Foundation

  #if canImport(os)
    import os
  #else
    import Logging
  #endif

  extension AnyPublisher where Output == Date, Failure == Never {
    static var snapshotLogger: Logger {
      BushelLogging.logger(forCategory: .machine)
    }

    static func automaticSnapshotPublisher(
      every interval: TimeInterval,
      tolerance: TimeInterval? = nil,
      on runLoop: RunLoop = .main,
      in mode: RunLoop.Mode = .common,
      options _: RunLoop.SchedulerOptions? = nil,
      isEnabled: Bool
    ) -> AnyPublisher<Date, Never> {
      if isEnabled {
        let tolerance = tolerance ?? Swift.min(interval / 2.0, 15.0)
        Self.snapshotLogger.debug(
          "Starting Automatic Snapshots every \(interval) secs with tolerance of \(tolerance) secs"
        )
        return Timer.publish(
          every: interval,
          tolerance: tolerance,
          on: runLoop,
          in: mode
        )
        .autoconnect()
        .eraseToAnyPublisher()
      } else {
        return Empty().eraseToAnyPublisher()
      }
    }
  }
#endif
