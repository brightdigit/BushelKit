//
// BushelDocument.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI) && canImport(os)
  import BushelMachine
  import os
  import SwiftUI
  import UniformTypeIdentifiers

  protocol BushelDocument: ReferenceFileDocument, LoggerCategorized {}

  extension BushelDocument {
    static var loggingCategory: LoggerCategory {
      .document
    }
  }
#endif
