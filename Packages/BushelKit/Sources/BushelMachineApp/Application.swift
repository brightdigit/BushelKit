//
// Application.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelMachine
  import BushelMachineMacOS
  import BushelMachineViews
  import BushelViewsCore
  import SwiftUI

  public protocol Application: App {
    // var appDelegate: AppDelegate { get }
  }

  public extension Application {
    var body: some Scene {
      MachineScene()
    }
  }
#endif
