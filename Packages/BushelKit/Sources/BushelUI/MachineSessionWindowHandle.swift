//
// MachineSessionWindowHandle.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

struct MachineSessionWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  
  
  let machineFilePath : String
  var path: String? {
    return self.machineFilePath
  }
  static let host = "session"
}
