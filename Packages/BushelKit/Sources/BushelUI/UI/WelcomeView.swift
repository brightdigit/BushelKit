//
// WelcomeView.swift
// Copyright (c) 2022 BrightDigit.
//

import SwiftUI
import UniformTypeIdentifiers

struct WelcomeView: View {
  var body: some View {
    HStack {
      WelcomeTitleView().frame(width: 600)
      WelcomeRecentDocumentsView().frame(width: 400)
    }
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
  }
}
