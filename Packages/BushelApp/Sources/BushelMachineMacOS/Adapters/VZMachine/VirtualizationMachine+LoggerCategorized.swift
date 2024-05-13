//
// VirtualizationMachine+LoggerCategorized.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelLogging

  extension VirtualizationMachine: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .machine
    }
  }
#endif
