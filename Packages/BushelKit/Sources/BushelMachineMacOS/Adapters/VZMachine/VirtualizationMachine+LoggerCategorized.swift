//
// VirtualizationMachine+LoggerCategorized.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelLogging

  extension VirtualizationMachine: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .machine
    }
  }
#endif
