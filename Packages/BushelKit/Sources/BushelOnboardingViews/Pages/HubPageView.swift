//
// HubPageView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import AVKit
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct HubPageView: View {
    @Environment(\.nextPage) var nextPage
    let avPlayer = AVPlayer.resource("onboarding-hubs")
    var body: some View {
      VStack(spacing: 8.0) {
        Spacer()
        Text(.onboardingHubTitle).font(.system(.title))
        Text(.onboardingHubMessage).padding(.horizontal, 80).multilineTextAlignment(.center)
        #if os(macOS)
          Video(using: avPlayer).aspectRatio(1.0, contentMode: .fit)
        #endif
        Spacer()
        Button(action: {
          nextPage()
        }, label: {
          Text(.onboardingNextButton).padding(4.0).padding(.horizontal, 40.0)
        }).buttonStyle(.borderedProminent)
      }.padding(.bottom, 40.0)
    }
  }

  #Preview {
    HubPageView().frame(width: 600, height: 600)
  }
#endif
