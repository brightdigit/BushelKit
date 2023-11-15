//
// AnyPublisher+AutomaticSnapshot.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Combine)
  import Combine
  import Foundation

  extension AnyPublisher where Output == Date, Failure == Never {
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
