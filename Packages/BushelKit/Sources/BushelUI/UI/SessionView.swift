//
// SessionView.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Combine
import SwiftUI

struct SessionView: View {
  @StateObject var sessionManager = SessionObject()
  var body: some View {
    Group {
      switch (self.sessionManager.sessionStartResult, self.sessionManager.sessionResult) {
      case let (.success, .success(session)):
        session.view
      case let (.failure(error), _):
        Text(error.localizedDescription)
      case let (_, .failure(error)):
        Text(error.localizedDescription)

      case (_, .none):
        ProgressView {
          Text("Creating Session...")
        }

      case (.none, .some(.success)):
        ProgressView {
          Text("Starting Session...")
        }
      }
    }.onOpenURL { externalURL in
      self.sessionManager.externalURL = externalURL
      dump(externalURL)
    }
  }
}

struct SessionView_Previews: PreviewProvider {
  static var previews: some View {
    SessionView()
  }
}
