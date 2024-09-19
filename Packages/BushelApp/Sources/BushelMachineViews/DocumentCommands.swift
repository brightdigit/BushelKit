//
// DocumentCommands.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
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
          Button {
            object.beginSynchronizing()
          } label: {
            Text(
              localizedUsingID: LocalizedStringID.machineDocumentCommandSynchronize,
              arguments: object.title
            )
          }
        }
      }
    }

    init(object: DocumentObject? = nil) {
      self.object = object
    }
  }

#endif
