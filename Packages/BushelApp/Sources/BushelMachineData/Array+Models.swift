//
// Array+Models.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelDataCore
  import Foundation
  import SwiftData

  private let _models: [any PersistentModel.Type] = [
    SnapshotEntry.self,
    MachineEntry.self
  ]

  extension Array where Element == any PersistentModel.Type {
    public static var machine: [any PersistentModel.Type] {
      _models
    }
  }
#endif
