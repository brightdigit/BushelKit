//
// FeatureListPageView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization

  public import RadiantKit

  public import SwiftUI

  internal struct FeatureListPageView: View {
    @Environment(\.nextPage) var nextPage
    let features: [FeatureItemView.Properties]
    var body: some View {
      VStack(spacing: 8.0) {
        Spacer()
        Text(.onboardingFeatureListHeader).font(.largeTitle)
        Spacer()
        ForEach(features) { properties in
          FeatureItemView(properties: properties).padding(.horizontal, 40)
        }
        Spacer()
        Button(action: {
          nextPage()
        }, label: {
          Text(.onboardingNextButton).padding(4.0).padding(.horizontal, 40.0)
        }).buttonStyle(.borderedProminent)
      }.padding(.bottom, 20.0).padding(20.0)
    }

    internal init(features: [FeatureItemView.Properties]) {
      self.features = features
    }

    internal init(@ArrayBuilder<FeatureItem> _ features: () -> [FeatureItem]) {
      self.init(features: features())
    }
  }

//  #Preview {
//    FeaureListView().frame(width: 600, height: 600)
//  }

#endif
