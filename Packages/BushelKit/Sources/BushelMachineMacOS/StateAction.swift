//
// StateAction.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import BushelVirtualization
  import Virtualization

  extension StateAction {
    init(machine: VZVirtualMachine) {
      let rawValue = [
        machine.canStart ? Self.start : nil,
        machine.canStop ? Self.stop : nil,
        machine.canPause ? Self.pause : nil,
        machine.canResume ? Self.resume : nil,
        machine.canRequestStop ? Self.requestStop : nil
      ].compactMap { $0?.rawValue }.reduce(0, +)
      self.init(rawValue: rawValue)
    }
  }
#endif
