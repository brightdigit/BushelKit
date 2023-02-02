//
// MachineView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineView: View {
    @Binding var document: MachineDocument
    var url: URL?
    var body: some View {
      Group {
        if let url = self.url {
          MachineDetailsView(document: self.$document, url: url)
        }
      }
    }
  }
#endif
