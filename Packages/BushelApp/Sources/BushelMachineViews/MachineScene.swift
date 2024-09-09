//
// MachineScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore
  import BushelFactoryViews
  import BushelFeatureFlags

  public import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData

  public import SwiftUI

  public struct MachineScene: Scene, Loggable {
    static let minimumWidth = 512.0
    static let idealSessionWidth = 1_920.0
    #if canImport(Virtualization) && arch(arm64)
      let system: VMSystemID
    #endif
    public var body: some Scene {
      #if canImport(Virtualization) && arch(arm64)
        WindowGroup("New Machine...", for: MachineBuildRequest.self) { request in
          DialogView(system: system, request: request).frame(width: 700, height: 400)
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        #endif
      #endif

      DocumentScene()
      #if os(macOS)
        WindowGroup(for: SessionRequest.self) { request in
          SessionView(request: request).nsWindowAdaptor {
            $0?.isRestorable = false
          }
        }
      #endif
    }

    #if canImport(Virtualization) && arch(arm64)
      public init(system: VMSystemID) {
        self.system = system
      }
    #else
      public init() {}
    #endif
  }

#endif
