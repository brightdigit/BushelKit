//
// MachineSessionWindowHandle.swift
// Copyright (c) 2022 BrightDigit.
//

struct MachineSessionWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  let machineFilePath: String
  var path: String? {
    machineFilePath
  }

  static let host = "session"
}