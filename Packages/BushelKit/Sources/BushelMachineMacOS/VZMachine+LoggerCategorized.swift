//
// VZMachine+LoggerCategorized.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelLogging

  extension VZMachine: LoggerCategorized {
    static var loggingCategory: Loggers.Category {
      .machine
    }
  }
#endif
