//
// MachineSessionWindowHandle.swift
// Copyright (c) 2023 BrightDigit.
//

struct MachineSessionWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  static let host = "session"
  let machineFilePath: String
  var path: String? {
    machineFilePath
  }
}
