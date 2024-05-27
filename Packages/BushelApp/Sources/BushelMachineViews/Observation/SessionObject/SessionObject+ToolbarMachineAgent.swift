//
// SessionObject+ToolbarMachineAgent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import BushelCore

  extension SessionObject: SessionToolbarAgent {
    var canPressPowerButton: Bool {
      self.canRequestStop
    }

    nonisolated func start() {
      self.begin {
        try await $0.start()
      }
    }

    nonisolated func pause() {
      self.begin {
        try await $0.pause()
      }
    }

    nonisolated func resume() {
      self.begin {
        try await $0.resume()
      }
    }

    nonisolated func snapshot(
      _ request: BushelMachine.SnapshotRequest,
      options: BushelMachine.SnapshotOptions
    ) {
      self.startSnapshot(request, options: options)
    }

    nonisolated func pressPowerButton() {
      self.beginShutdown()
    }
  }
#endif
