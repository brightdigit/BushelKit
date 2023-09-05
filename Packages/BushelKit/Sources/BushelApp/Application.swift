//
// Application.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(os)
  import os
#else
  import Logging
#endif

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelFactory
  import BushelHub
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import BushelMachine
  import BushelSystem
  import BushelViews
  import BushelViewsCore
  import BushelVirtualization
  import SwiftData
  import SwiftUI

  public protocol Application: App, LoggerCategorized {
    // var appDelegate: AppDelegate { get }
  }

  public extension Application {
    static var loggingCategory: Loggers.LoggerCategory {
      .application
    }

    var body: some Scene {
      Group {
        WelcomeScene()
        LibraryScene()
        MachineScene()
        Settings()
      }
      .commands(content: {
        CommandGroup(replacing: .newItem) {
          Menu("New") {
            Library.NewCommands()
            Machine.NewCommands()
          }
          Divider()
          Menu("Open") {
            Library.OpenCommands()
            Machine.OpenCommands()
          }
        }
        CommandGroup(before: .singleWindowList) {
          Welcome.WindowCommands()
        }
      })
      .configure(
        libraryFileType: LibraryFileSpecifications.self,
        machineFileType: MachineFileTypeSpecification.self
      ) {
        #if arch(arm64)
          MacOSVirtualizationSystem()
        #endif
      }
    }
  }
#endif
