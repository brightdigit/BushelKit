//
// SessionObject+ToolbarMachineAgent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine
import BushelMarket

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)

  extension SessionObject: SessionToolbarAgent {
    var allowedToSaveSnapshot: Bool {
      assert(purchased != nil)
      if purchased == true {
        return true
      }

      guard let machineObject else {
        return false
      }

      return machineObject.snapshotIDs.count < PaywallConfiguration.shared.maximumNumberOfFreeSnapshots
    }

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
