//
// BushelDocument.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(os)
  import BushelMachine
  import FelinePine
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
