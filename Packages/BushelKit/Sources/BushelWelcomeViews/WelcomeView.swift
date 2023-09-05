//
// WelcomeView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct WelcomeView: View {
    struct Value: Codable, Hashable {
      private init() {}
      static let `default` = Value()
    }

    init() {}

    init(_: Binding<Value>) {
      self.init()
    }

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
      HStack {
        WelcomeTitleView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(
            colorScheme == .dark ?
              Color.black.opacity(0.35) :
              Color.white
          )

        WelcomeRecentDocumentsView().frame(width: 280)
      }.frame(width: 750, height: 440)
        .navigationTitle("Welcome to Bushel")
    }
  }

  #Preview {
    WelcomeView()
  }
#endif
