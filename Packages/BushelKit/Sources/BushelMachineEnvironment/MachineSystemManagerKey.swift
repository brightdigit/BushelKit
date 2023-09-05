//
// MachineSystemManagerKey.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  private struct MachineSystemManagerKey: EnvironmentKey {
    static let defaultValue: MachineSystemManaging =
      MachineSystemManager([])
  }

  public extension EnvironmentValues {
    var machineSystemManager: MachineSystemManaging {
      get { self[MachineSystemManagerKey.self] }
      set { self[MachineSystemManagerKey.self] = newValue }
    }
  }

  public extension Scene {
    func machineSystemManager(
      _ systemManager: MachineSystemManaging
    ) -> some Scene {
      self.environment(\.machineSystemManager, systemManager)
    }
  }
#endif
