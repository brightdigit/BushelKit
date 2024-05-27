//
// SessionObject+Snapshots.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import BushelCore

  extension SessionObject {
    func stop(saveSnapshot request: SnapshotRequest?) {
      guard let machineObject, let url else {
        assertionFailure("Missing machine or url.")
        return
      }
      Task {
        if let request {
          try await machineObject.saveSnapshot(request, options: [], at: url)
        }
        try await machineObject.machine.stop()
      }
    }

    nonisolated func startSnapshot(_ request: SnapshotRequest, options: SnapshotOptions) {
      Task { @MainActor in
        guard let machineObject, let url else {
          assertionFailure("Missing machine or url.")
          return
        }
        machineObject.beginSavingSnapshot(request, options: options, at: url)
      }
    }

    func beginSnapshot() {
      guard let machine = machineObject?.machine else {
        assertionFailure("Missing machine or url.")
        return
      }

      Task {
        if machine.canPause {
          do {
            try await machine.pause()
          } catch let error as MachineError {
            self.error = error
          } catch {
            assertionFailure(error: error)
          }
        }
      }
    }
  }
#endif
