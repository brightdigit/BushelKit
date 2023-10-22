//
// WelcomeTitleView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelMarketEnvironment
  import BushelUT
  import BushelViewsCore
  import SwiftUI
  import UniformTypeIdentifiers

  struct WelcomeTitleView: View, LoggerCategorized {
    var body: some View {
      HStack {
        Spacer()
        VStack {
          Spacer()
          Image.resource("Logo").resizable().aspectRatio(contentMode: .fit).frame(height: 120)
          WelcomeLogoTitleLabelView()
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
