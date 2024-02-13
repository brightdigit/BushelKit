//
// MachineScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  public struct MachineScene: Scene, Loggable {
    static let minimumWidth = 512.0
    static let idealSessionWidth = 1920.0

    public var body: some Scene {
      WindowGroup("New Machine...", for: MachineBuildRequest.self) { request in
        #if os(macOS)
          ConfigurationView(request: request).presentedWindowStyle(.hiddenTitleBar)
        #else
          ConfigurationView(request: request)
        #endif
      }
      DocumentScene()
      #if os(macOS)
        WindowGroup(for: SessionRequest.self) { request in
          SessionView(request: request).nsWindowAdaptor {
            $0?.isRestorable = false
          }
        }
      #endif
    }

    public init() {}
  }

#endif
