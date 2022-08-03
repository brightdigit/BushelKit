//
// MachineSessionView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import SwiftUI
import Virtualization
#warning("Remove `import Virtualization`")

struct MachineSessionView: View {
  @State var startError: Error?
  @State var isSessionDisplayVisible = false
  @Binding var document: MachineDocument
  let url: URL
  var body: some View {
    VStack {
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
      Text("Hello World")
    }.onAppear {
      do {
        try document.beginLoadingFromURL(url)
      } catch {
        dump(error)
      }
    }.sheet(isPresented: $isSessionDisplayVisible) {
      if let vm = document.session as? VZVirtualMachine {
        VirtualMachineView(virtualMachine: vm)
      }
    }
  }
}

// struct MachineSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MachineSessionView()
//    }
// }
