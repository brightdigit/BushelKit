//
// MachineState.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import BushelVirtualization
  import Virtualization

  extension MachineState {
    init(vzMachineState: VZVirtualMachine.State) {
      // swiftlint:disable:next force_unwrapping
      self.init(rawValue: vzMachineState.rawValue)!
    }
  }
#endif
