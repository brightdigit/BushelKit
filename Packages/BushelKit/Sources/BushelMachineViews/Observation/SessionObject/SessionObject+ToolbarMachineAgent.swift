//
// SessionObject+ToolbarMachineAgent.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import BushelCore

  extension SessionObject: SessionToolbarAgent {
    var canPressPowerButton: Bool {
      self.canRequestStop
    }

    func start() {
      self.begin {
        try await $0.start()
      }
    }

    func pause() {
      self.begin {
        try await $0.pause()
      }
    }

    func resume() {
      self.begin {
        try await $0.resume()
      }
    }

    func snapshot(_ request: BushelMachine.SnapshotRequest, options: BushelMachine.SnapshotOptions) {
      self.startSnapshot(request, options: options)
    }

    func pressPowerButton() {
      self.beginShutdown()
    }
  }
#endif
