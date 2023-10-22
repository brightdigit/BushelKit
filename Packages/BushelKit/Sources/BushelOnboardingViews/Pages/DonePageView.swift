//
// DonePageView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import AVKit
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct DonePageView: View {
    @Environment(\.nextPage) var nextPage
    let avPlayer = AVPlayer.resource("onboarding-done")
    var body: some View {
      VStack(spacing: 8.0) {
        Spacer()
        Text(.onboardingDoneTitle)
          .font(.system(.title))
        Text(.onboardingDoneMessage)
          .padding(.horizontal, 80)
          .multilineTextAlignment(.center)
        #if os(macOS)
          Video(using: avPlayer).aspectRatio(1.0, contentMode: .fit)
        #endif
        Spacer()
        Button(action: {
          nextPage()
        }, label: {
          Text(.onboardingDoneButton)
            .padding(4.0)
            .padding(.horizontal, 40.0)
        }).buttonStyle(.borderedProminent)
      }.padding(.bottom, 40.0)
    }
  }

  #Preview {
    DonePageView().frame(width: 600, height: 600)
  }
#endif
