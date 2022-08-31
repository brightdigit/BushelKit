//
// MachineState.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Virtualization

extension MachineState {
  init(vzMachineState: VZVirtualMachine.State) {
    self.init(rawValue: vzMachineState.rawValue)!
  }
}
