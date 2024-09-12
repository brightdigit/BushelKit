//
// MachineSystemManagerKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore

  public import BushelMachine
  import Foundation
  import SwiftData

  public import SwiftUI

  private struct MachineSystemManagerKey: EnvironmentKey {
    static let defaultValue: any MachineSystemManaging =
      MachineSystemManager([])
  }

  extension EnvironmentValues {
    public var machineSystemManager: any MachineSystemManaging {
      get { self[MachineSystemManagerKey.self] }
      set { self[MachineSystemManagerKey.self] = newValue }
    }
  }

  extension Scene {
    public func machineSystemManager(
      _ systemManager: any MachineSystemManaging
    ) -> some Scene {
      self.environment(\.machineSystemManager, systemManager)
    }
  }
#endif
