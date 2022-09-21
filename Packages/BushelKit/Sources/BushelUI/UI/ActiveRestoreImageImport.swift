//
// ActiveRestoreImageImport.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Foundation

public extension ActiveRestoreImageImport {
  var localizedImportingMessage: String {
    [
      Bundle.module.localizedString(forKey: "importing", value: nil, table: nil),
      sourceURL.lastPathComponent
    ].joined(separator: " ").appending("...")
  }
}
