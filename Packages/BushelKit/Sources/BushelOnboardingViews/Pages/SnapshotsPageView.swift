//
// SnapshotsPageView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import AVKit
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct SnapshotsPageView: View {
    @Environment(\.nextPage) var nextPage
    let avPlayer = AVPlayer.resource("onboarding-snapshots")
    var body: some View {
      VStack(spacing: 8.0) {
        Spacer()
        Text(.onboardingSnapshotsTitle).font(.system(.title))
        Text(.onboardingSnapshotsMessage).padding(.horizontal, 80).multilineTextAlignment(.center)
        #if os(macOS)
          Video(using: avPlayer).aspectRatio(1.0, contentMode: .fit)
        #endif
        Spacer()
        Button(action: {
          nextPage()
        }, label: {
          Text(.onboardingNextButton).padding(4.0).padding(.horizontal, 40.0)
        }).buttonStyle(.borderedProminent)
      }.padding(.bottom, 20.0).padding(20.0)
    }
  }

  #Preview {
    SnapshotsPageView().frame(width: 600, height: 600)
  }
#endif
