//
// WelcomeView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelViewsCore
  import SwiftUI

  struct WelcomeView: SingleWindowView {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("recentDocumentsClearDate") private var recentDocumentsClearDate: Date?
    var body: some View {
      HStack {
        WelcomeTitleView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(
            colorScheme == .dark ?
              Color.black.opacity(0.35) :
              Color.white
          )

        WelcomeRecentDocumentsView(recentDocumentsClearDate: recentDocumentsClearDate).frame(width: 280)
      }.frame(width: 750, height: 440)
        .navigationTitle("Welcome to Bushel")
    }

    init() {}
  }

  #Preview {
    WelcomeView()
  }
#endif
