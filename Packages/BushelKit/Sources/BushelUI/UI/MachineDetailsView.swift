//
// MachineDetailsView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/13/22.
//

import BushelMachine
import SwiftUI

struct MachineDetailsView: View {
  let url: URL

  internal init(document: Binding<MachineDocument>, url: URL) {
    _document = document
    self.url = url
  }

  @State var validationResult: Result<Void, Error>?
  @Binding var document: MachineDocument
  var body: some View {
    VStack {
      Text("hello world")
      switch self.validationResult {
      case .success:
        Button("Start") {
          Windows.openWindow(withHandle: MachineSessionWindowHandle(machineFilePath: url.path))
        }
      case let .failure(error):
        Button("Dump Error \(error.localizedDescription)") {
          dump(error)
        }
      case .none:
        ProgressView {
          Text("Loading Machine...")
        }
      }
    }
    .onAppear {
      self.validationResult = Result {
        try self.document.validateSessionAt(self.url)
      }
    }
  }
}
