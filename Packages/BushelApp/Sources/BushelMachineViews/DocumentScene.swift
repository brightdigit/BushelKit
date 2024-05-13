//
// DocumentScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  struct DocumentScene: Scene {
    @FocusedValue(\.machineDocument) var object
    var body: some Scene {
      WindowGroup(for: MachineFile.self) { file in
        #if os(macOS)
          DocumentView(
            machineFile: file
          ).nsWindowAdaptor {
            $0?.isRestorable = false
          }
          .presentedWindowToolbarStyle(.expanded)
        #else
          DocumentView(machineFile: file)
        #endif
      }.commands {
        DocumentCommands(object: object)
      }
    }
  }

#endif
