//
// VirtualizationMachine+PreviousAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)

  extension VirtualizationMachine {
    enum PreviousAction {
      case pause
      case start
    }
  }
#endif
