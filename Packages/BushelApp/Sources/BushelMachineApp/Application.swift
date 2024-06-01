//
// Application.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import BushelMachineData
  import BushelMachineMacOS
  import BushelMachineViews
  import BushelMacOSCore
  import BushelViewsCore
  import SwiftUI

  public protocol Application: App {
    // var appDelegate: AppDelegate { get }
  }

  extension Application {
    public var body: some Scene {
      #if canImport(Virtualization) && arch(arm64)
        MachineScene(system: .macOS)
      #else
        MachineScene()
      #endif
    }
  }
#endif
