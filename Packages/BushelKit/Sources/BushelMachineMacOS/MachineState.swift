//
// MachineState.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension MachineState {
    init(vzMachineState: VZVirtualMachine.State) {
      self.init(rawValue: vzMachineState.rawValue)!
    }
  }
#endif
