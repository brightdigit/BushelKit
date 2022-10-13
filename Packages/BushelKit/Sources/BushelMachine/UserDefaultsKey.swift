//
// UserDefaultsKey.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public enum UserDefaultsKey: String {
  case images = "BDBSHRestoreImages"
  case machines = "BDBSHMachines"
  case libraries = "BDBSHLibrariesData"
}

public extension UserDefaultsKey {
  func data(_ data: Data) -> UserDefaultData {
    UserDefaultData(key: self, data: data)
  }
}
