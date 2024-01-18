//
// MachineSystemError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelTestUtlities
import Foundation

internal struct MachineSystemError: MockError {
  static let createBuilderForConfiguration: Self = .init(value: "createBuilderForConfiguration")
  static let machineAtURL: Self = .init(value: "machineAtURL")
  static let restoreImage: Self = .init(value: "restoreImage")

  var value: String
}
