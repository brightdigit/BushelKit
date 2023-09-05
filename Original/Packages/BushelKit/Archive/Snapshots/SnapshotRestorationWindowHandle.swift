//
// SnapshotRestorationWindowHandle.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

struct SnapshotRestorationWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  static let host: String = "ssrestore"
  let snapshotPath: SnapshotPath

  var path: String? {
    snapshotPath.path
  }

  internal init(snapshotPath: SnapshotPath) {
    self.snapshotPath = snapshotPath
  }
}
