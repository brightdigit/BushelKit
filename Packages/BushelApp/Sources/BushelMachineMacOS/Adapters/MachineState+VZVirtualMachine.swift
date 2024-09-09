//
// MachineState+VZVirtualMachine.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension MachineState {
    @Sendable
    init?(state: VZVirtualMachine.State) {
      self.init(rawValue: state.rawValue)
    }
  }
#endif
