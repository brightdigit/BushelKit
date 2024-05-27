//
// DocumentCommands.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  @MainActor
  internal struct DocumentCommands: Commands {
    let object: DocumentObject?

    var body: some Commands {
      if let object, false {
        CommandMenu("Machine") {
          Button("Syncronize \(object.title)") {
            object.beginSyncronizing()
          }
        }
      }
    }

    init(object: DocumentObject? = nil) {
      self.object = object
    }
  }

#endif
