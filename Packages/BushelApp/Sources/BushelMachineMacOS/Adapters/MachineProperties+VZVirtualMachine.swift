//
// MachineProperties+VZVirtualMachine.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension MachineProperties {
    init?(machine: VZVirtualMachine) {
      let state = MachineState(state: machine.state)
      assert(state != nil)
      guard let state else {
        return nil
      }
      self.init(
        state: state,
        canStart: machine.canStart,
        canStop: machine.canStop,
        canPause: machine.canPause,
        canResume: machine.canResume,
        canRequestStop: machine.canRequestStop
      )
    }
  }
#endif
