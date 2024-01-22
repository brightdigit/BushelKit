//
// MachineSystemManagerKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  private struct MachineSystemManagerKey: EnvironmentKey {
    static let defaultValue: any MachineSystemManaging =
      MachineSystemManager([])
  }

  public extension EnvironmentValues {
    var machineSystemManager: any MachineSystemManaging {
      get { self[MachineSystemManagerKey.self] }
      set { self[MachineSystemManagerKey.self] = newValue }
    }
  }

  public extension Scene {
    func machineSystemManager(
      _ systemManager: any MachineSystemManaging
    ) -> some Scene {
      self.environment(\.machineSystemManager, systemManager)
    }
  }
#endif
