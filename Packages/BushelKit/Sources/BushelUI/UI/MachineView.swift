//
// MachineView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/7/22.
//

import BushelMachine
import SwiftUI

struct MachineView: View {
  @Binding var document: MachineDocument
  var url: URL?
  let restoreImageChoices: [MachineRestoreImage]
  var body: some View {
    Group {
      if document.machine.operatingSystem == nil {
        MachineSetupView(document: self.$document, url: self.url, restoreImageChoices: restoreImageChoices, onCompleted: nil)
      } else if let url = self.url {
        MachineSessionView(document: self.$document, url: url)
      }
    }
  }
}
