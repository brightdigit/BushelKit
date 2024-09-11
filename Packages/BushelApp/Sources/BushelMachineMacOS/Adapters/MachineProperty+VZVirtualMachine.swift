//
// MachineProperty+VZVirtualMachine.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension MachineProperty {
    // swiftlint:disable:next cyclomatic_complexity
    init?(keypath: KeyPath<VZVirtualMachine, some Any>) {
      switch keypath {
      case \.state:
        self = .state
      case \.canStart:
        self = .canStart
      case \.canStop:
        self = .canStop
      case \.canPause:
        self = .canPause
      case \.canResume:
        self = .canResume
      case \.canRequestStop:
        self = .canRequestStop
      default:
        return nil
      }
    }
  }
#endif
