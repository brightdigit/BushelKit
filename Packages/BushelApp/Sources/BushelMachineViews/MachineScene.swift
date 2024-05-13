//
// MachineScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelFactoryViews
  import BushelFeatureFlags
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  public struct MachineScene: Scene, Loggable {
    static let minimumWidth = 512.0
    static let idealSessionWidth = 1_920.0
    let system: VMSystemID?
    @Environment(\.newDesignFeature) var newDesignFeature
    public var body: some Scene {
      WindowGroup("New Machine...", for: MachineBuildRequest.self) { request in
        if let system, newDesignFeature.value {
          DialogView(system: system, request: request).frame(width: 700, height: 400)
        } else {
          #if os(macOS)
            ConfigurationView(request: request).presentedWindowStyle(.hiddenTitleBar)
          #else
            ConfigurationView(request: request)
          #endif
        }
      }
      #if os(macOS)
      .windowStyle(.hiddenTitleBar)
      .windowResizability(.contentSize)
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

    public init(system: VMSystemID? = nil) {
      self.system = system
    }
  }

#endif
