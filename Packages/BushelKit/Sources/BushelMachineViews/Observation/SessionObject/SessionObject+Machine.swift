//
// SessionObject+Machine.swift
// Copyright (c) 2024 BrightDigit.
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

    func begin(_ closure: @escaping @Sendable (any BushelMachine.Machine) async throws -> Void) {
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

    func beginForceRestart() {
      self.begin { machine in
        self.isRestarting = true
        try await machine.stop()
        try await machine.start()
        self.isRestarting = false
      }
    }

    func onCanStartChange(_: Bool, _ newValue: Bool) {
      guard newValue, !self.hasIntialStarted else {
        return
      }

      self.hasIntialStarted = true
      self.begin {
        try await $0.start()
      }
    }

    func onStateChanged(
      from oldValue: MachineState,
      to newValue: MachineState,
      withPurchase hasPurchased: Bool,
      shutdownOption: MachineShutdownActionOption?,
      _ completed: @escaping @Sendable @MainActor () -> Void
    ) {
      Task { @MainActor in
        self.updateWindowSize()
        if
          !self.isRestarting,
          oldValue != .stopped,
          newValue == .stopped,
          !self.keepWindowOpenOnShutdown ||
          shutdownOption == .closeWindow {
          self.hasIntialStarted = false
          if hasPurchased {
            self.startSnapshot(.init(), options: .discardable)
          }
          completed()
        }
      }
    }
  }
#endif
