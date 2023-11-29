//
// MachineScene.swift
// Copyright (c) 2023 BrightDigit.
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
      WindowGroup(for: MachineFile.self) { file in
        #if os(macOS)
          DocumentView(machineFile: file).nsWindowAdaptor {
            $0?.isRestorable = false
          }
          .presentedWindowToolbarStyle(.expanded)
        #else
          DocumentView(machineFile: file)
        #endif
      }
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
