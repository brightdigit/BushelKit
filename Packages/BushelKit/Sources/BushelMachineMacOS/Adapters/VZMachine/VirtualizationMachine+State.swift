//
// VirtualizationMachine+State.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelMachine

  extension VirtualizationMachine {
    var state: MachineState {
      // swiftlint:disable:next force_unwrapping
      .init(rawValue: machine.state.rawValue)!
    }

    @MainActor
    var canStart: Bool {
      self.machine.canStart
    }

    @MainActor
    var canStop: Bool {
      self.machine.canStop
    }

    @MainActor
    var canPause: Bool {
      self.machine.canPause
    }

    @MainActor
    var canResume: Bool {
      self.machine.canResume
    }

    @MainActor
    var canRequestStop: Bool {
      self.machine.canRequestStop
    }
  }
#endif
