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
  import BushelOnboardingViews
  import BushelSystem
  import BushelViews
  import BushelViewsCore
  import BushelVirtualization
  import SwiftData
  import SwiftUI

  #if DEBUG
    import BushelWax
  #endif

  public protocol Application: App, Loggable {
    var scenePhase: ScenePhase { get }
  }

  public extension Application {
    static var loggingCategory: BushelLogging.Category {
      .application
    }

    var body: some Scene {
      Group {
        #if os(macOS)
          WelcomeScene()
          Settings(purchaseScreenValue: MarketScene.purchaseScreenValue).windowResizability(.contentSize)
        #endif

        LibraryScene()
        MachineScene()

        MarketScene()
        OnboardingScene()
      }
      .commands(content: {
        CommandGroup(replacing: .newItem) {
          Menu("New") {
            #if os(macOS)
              Library.NewCommands()
            #endif
            Machine.NewCommands()
          }
          #if os(macOS)
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
          #endif
        }
        #if os(macOS)
          CommandGroup(before: .singleWindowList) {
            Welcome.WindowCommands()
          }
          CommandGroup(replacing: .help) {
            Welcome.HelpCommands()
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
        #if DEBUG
          MockSystem()
        #endif
      }
      .marketplace(onChangeOf: scenePhase)
    }
  }
#endif
