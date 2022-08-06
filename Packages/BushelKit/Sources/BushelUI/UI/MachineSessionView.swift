//
// MachineSessionView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import BushelMachine
import SwiftUI
import Virtualization
#warning("Remove `import Virtualization`")

struct MachineSessionView: View {
  let url: URL

  internal init(document: Binding<MachineDocument>, url: URL) {
    _document = document
    self.url = url
    // self.document.updateFileAccessorURL(url)
  }

  @State var startError: Error?
  @State var isSessionDisplayVisible = false
  @Binding var document: MachineDocument
  var body: some View {
    VStack {
      Text("hello world")
      if let session = document.session {
        Button("Start") {
          Task {
            let caughtError: Error?
            do {
              try await session.begin()
              caughtError = nil
            } catch {
              caughtError = error
            }
            DispatchQueue.main.async {
              if let error = caughtError {
                self.startError = error
              } else {
                isSessionDisplayVisible = true
              }
            }
          }
        }
      }
    }.sheet(isPresented: $isSessionDisplayVisible) {
      if let vm = document.session as? VZVirtualMachine {
        VirtualMachineView(virtualMachine: vm)
      }
    }
    .onAppear {
      try? self.document.loadSession(from: url)
    }
  }
}

// struct MachineSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MachineSessionView()
//    }
// }