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

  public extension Application {
    var body: some Scene {
      MachineScene(system: .macOS)
    }
  }
#endif
