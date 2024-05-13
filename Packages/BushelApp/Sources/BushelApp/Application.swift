//
// Application.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelFactory
  import BushelHub
  import BushelHubIPSW
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

  extension Application {
    public static var loggingCategory: BushelLogging.Category {
      .application
    }

    public var defaultSystem: VMSystemID? {
      #if arch(arm64) && os(macOS)
        MacOSVirtualizationSystem.systemID
      #else
        nil
      #endif
    }

    public var body: some Scene {
      Group {
        #if os(macOS)
          WelcomeScene()
          Settings(purchaseScreenValue: MarketScene.purchaseScreenValue).windowResizability(.contentSize)
        #endif

        LibraryScene()
        MachineScene(system: defaultSystem)

        MarketScene()
        OnboardingScene()
      }
      .commands(content: {
        CommandGroup(replacing: .newItem) {
          Menu {
            #if os(macOS)
              Library.NewCommands()
            #endif
            Machine.NewCommands()
          } label: {
            Text(.menuNew)
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
          IPSWDownloads.hubs
        #endif
        #if DEBUG
          MockSystem()
        #endif
      }
      .marketplace(onChangeOf: scenePhase)
    }
  }
#endif