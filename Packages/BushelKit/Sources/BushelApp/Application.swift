//
// Application.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelFactory
  import BushelHub
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import BushelMachine
  import BushelMarketEnvironment
  import BushelMarketStore
  import BushelMarketViews
  import BushelSystem
  import BushelViews
  import BushelViewsCore
  import BushelVirtualization
  import SwiftData
  import SwiftUI

  #if WAX_FRUIT
    import BushelWax
  #endif

  public protocol Application: App, LoggerCategorized {
    // var appDelegate: AppDelegate { get }
    var scenePhase: ScenePhase { get }
  }

  public extension Application {
    static var loggingCategory: Loggers.LoggerCategory {
      .application
    }

    var body: some Scene {
      Group {
        #if os(macOS)
          WelcomeScene()
          Settings(purchaseScreenValue: MarketScene.purchaseScreenValue)
        #endif

        LibraryScene()
        MachineScene()

        MarketScene()
      }
      .commands(content: {
        CommandGroup(replacing: .newItem) {
          Menu("New") {
            #if os(macOS)
              Library.NewCommands()
            #endif
            Machine.NewCommands()
          }
          Divider()
          Welcome.OpenCommands()
            .configure(
              libraryFileType: LibraryFileSpecifications.self,
              machineFileType: MachineFileTypeSpecification.self
            ) {
              #if arch(arm64) && os(macOS)
                MacOSVirtualizationSystem()
              #endif
              #if WAX_FRUIT
                MockSystem()
              #endif
            }
        }
        #if os(macOS)
          CommandGroup(before: .singleWindowList) {
            Welcome.WindowCommands()
          }
        #endif
      })
      .configure(
        libraryFileType: LibraryFileSpecifications.self,
        machineFileType: MachineFileTypeSpecification.self
      ) {
        #if arch(arm64) && os(macOS)
          MacOSVirtualizationSystem()
        #endif
        #if WAX_FRUIT
          MockSystem()
        #endif
      }
      .marketplace(onChangeOf: scenePhase)
    }
  }
#endif
