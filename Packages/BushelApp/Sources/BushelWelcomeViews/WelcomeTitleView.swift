//
// WelcomeTitleView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLocalization
  import BushelLogging
  import BushelMarketEnvironment
  import BushelUT
  import BushelViewsCore
  import SwiftUI
  import UniformTypeIdentifiers

  struct WelcomeTitleView: View, Loggable {
    @Environment(\.marketplace) var marketplace
    var body: some View {
      HStack {
        Spacer()
        VStack {
          Spacer()
          VStack {
            Image.resource("Logo").resizable().aspectRatio(contentMode: .fit).frame(height: 120)

            WelcomeLogoTitleLabelView()
          }
          .accessibilityElement(children: .contain)
          Spacer(minLength: 10.0)
          WelcomeActionListView()
            .padding(20.0)
          Spacer()
        }.padding()
        Spacer()
      }
    }
  }

  struct WelcomeTitleView_Previews: PreviewProvider {
    static var previews: some View {
      WelcomeTitleView()
    }
  }
#endif
