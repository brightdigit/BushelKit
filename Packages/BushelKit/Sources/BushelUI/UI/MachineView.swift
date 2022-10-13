//
// MachineView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineView: View {
    @Binding var document: MachineDocument
    var url: URL?
    var body: some View {
      Group {
        if document.machine.operatingSystem == nil {
          MachineSetupView(
            document: self.$document,
            url: self.url,
            onCompleted: nil
          )
        } else if let url = self.url {
          MachineDetailsView(document: self.$document, url: url)
        }
      }
    }
  }
#endif
