//
// MachineState.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension MachineState {
    init(vzMachineState: VZVirtualMachine.State) {
      // swiftlint:disable:next force_unwrapping
      self.init(rawValue: vzMachineState.rawValue)!
    }
  }
#endif
