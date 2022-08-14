//
// MachineSessionWindowHandle.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/13/22.
//

struct MachineSessionWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  let machineFilePath: String
  var path: String? {
    machineFilePath
  }

  static let host = "session"
}
