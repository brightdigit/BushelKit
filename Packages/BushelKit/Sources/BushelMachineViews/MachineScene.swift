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

  public struct MachineScene: Scene, LoggerCategorized {
    public init() {}

    public var body: some Scene {
      WindowGroup("New Machine...", for: MachineBuildRequest.self) { request in
        ConfigurationView(request: request).presentedWindowStyle(.hiddenTitleBar)
      }
      WindowGroup(for: MachineFile.self) { file in
        DocumentView(machineFile: file).nsWindowAdaptor {
          $0?.isRestorable = false
        }.presentedWindowToolbarStyle(.expanded)
      }
      WindowGroup(for: SessionRequest.self) { request in
        SessionView(request: request).nsWindowAdaptor {
          $0?.isRestorable = false
        }
      }
    }
  }
#endif
