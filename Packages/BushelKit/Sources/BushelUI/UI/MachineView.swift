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
    let restoreImageChoices: [MachineRestoreImage]
    var body: some View {
      Group {
        if document.machine.operatingSystem == nil {
          MachineSetupView(
            document: self.$document,
            restoreImageChoices: restoreImageChoices,
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
