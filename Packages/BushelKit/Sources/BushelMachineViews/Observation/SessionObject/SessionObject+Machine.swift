//
// SessionObject+Machine.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import BushelCore

  extension SessionObject {
    var state: MachineState {
      self.machineObject?.state ?? .stopped
    }

    var canStart: Bool {
      self.machineObject?.canStart ?? false
    }

    var canStop: Bool {
      self.machineObject?.canStop ?? false
    }

    var canPause: Bool {
      self.machineObject?.canPause ?? false
    }

    var canResume: Bool {
      self.machineObject?.canResume ?? false
    }

    var canRequestStop: Bool {
      self.machineObject?.canRequestStop ?? false
    }

    func begin(_ closure: @escaping (any BushelMachine.Machine) async throws -> Void) {
      guard let machine = machineObject?.machine else {
        assertionFailure("Missing machine to start with.")
        return
      }
      Task {
        @MainActor in
        do {
          try await closure(machine)
        } catch {
          self.error = MachineError.fromSessionAction(error: error)
        }
      }
    }

    func beginShutdown() {
      self.begin {
        try await $0.requestStop()
      }
    }
  }
#endif
