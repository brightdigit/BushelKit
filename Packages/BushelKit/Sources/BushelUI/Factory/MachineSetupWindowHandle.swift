//
// MachineSetupWindowHandle.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

struct MachineSetupWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  static let host = "build"
  let restoreImagePath: RestoreImagePath?
  var path: String? {
    restoreImagePath?.path
  }

  internal init(restoreImagePath: RestoreImagePath? = nil) {
    self.restoreImagePath = restoreImagePath
  }
}
