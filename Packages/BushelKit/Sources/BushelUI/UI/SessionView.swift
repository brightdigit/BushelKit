//
// SessionView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Combine) && canImport(SwiftUI)

  import BushelMachine
  import Combine
  import SwiftUI

  struct SessionView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    @StateObject var sessionManager = SessionObject()

    var body: some View {
      Group {
        switch (self.sessionManager.lastError, self.sessionManager.machineState, self.sessionManager.session) {
        case let (.some(error), _, _):
          Text(error.localizedDescription)
        case let (.none, _, .some(session)):
          session.view
        case (.none, _, .none):
          ProgressView {
            Text("Creating Session...")
          }
        }
      }.toolbar {
        ToolbarItemGroup {
          Button {
            self.sessionManager.beginPause()
          } label: {
            Image(systemName: "pause.fill")
          }

          Button {
            self.sessionManager.beginResume()
          } label: {
            Image(systemName: "playpause.fill")
          }
          Button {
            self.sessionManager.requestStop()
          } label: {
            Image(systemName: "stop.fill")
          }

          Button {
            if self.sessionManager.externalURL == nil {
              dismiss()
            } else if self.sessionManager.machineState == nil {
              dismiss()
            } else if self.sessionManager.machineState == .stopped {
              dismiss()
            } else {
              self.sessionManager.beginStop()
            }

          } label: {
            Image(systemName: "xmark.square.fill")
          }
        }
      }
      .onOpenURL { externalURL in
        self.sessionManager.externalURL = externalURL
      }
    }
  }

  struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
      SessionView()
    }
  }
#endif
