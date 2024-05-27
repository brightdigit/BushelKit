//
// MachineDocumentKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  internal struct MachineDocumentKey: FocusedValueKey {
    typealias Value = DocumentObject
  }

  extension FocusedValues {
    var machineDocument: MachineDocumentKey.Value? {
      get {
        self[MachineDocumentKey.self]
      }
      set {
        self[MachineDocumentKey.self] = newValue
      }
    }
  }

#endif
