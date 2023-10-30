//
// FeaureListView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct FeaureListView: View {
    @Environment(\.nextPage) var nextPage
    var body: some View {
      VStack(spacing: 8.0) {
        Spacer()
        Text(.onboardingFeatureListHeader).font(.largeTitle)
        Spacer()
        FeatureItem(
          systemName: "questionmark.circle.fill",
          title: "Manage Multiple Virtual Machines",
          description: "Quis imperdiet massa tincidunt nunc pulvinar sapien et ligula."
        )

        FeatureItem(
          systemName: "questionmark.circle.fill",
          title: "Snapshot and Rewind",
          description: "Quis imperdiet massa tincidunt nunc pulvinar sapien et ligula."
        )

        FeatureItem(
          systemName: "questionmark.circle.fill",
          title: "Track Multiple Restore Images",
          description: "Quis imperdiet massa tincidunt nunc pulvinar sapien et ligula."
        )

        FeatureItem(
          systemName: "questionmark.circle.fill",
          title: "Expirement, Break, and Repeat",
          description: "Quis imperdiet massa tincidunt nunc pulvinar sapien et ligula."
        )
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
    FeaureListView().frame(width: 600, height: 600)
  }

#endif
