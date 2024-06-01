//
// FeatureListView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import RadiantKit
  import SwiftUI

  internal struct FeatureListView: View {
    let titleID: LocalizedID
    let features: [FeatureItemView.Properties]
    let action: (@Sendable @MainActor () -> Void)?
    var body: some View {
      VStack(spacing: 8.0) {
        Text(titleID).font(.largeTitle)
        Spacer()
        ForEach(features) { properties in
          FeatureItemView(properties: properties).padding(.horizontal, 40)
        }
        Button(action: {
          self.action?()
        }, label: {
          Text(.onboardingNextButton).padding(4.0).padding(.horizontal, 40.0)
        }).buttonStyle(.borderedProminent)
      }.padding(.bottom, 20.0).padding(20.0)
    }

    internal init(
      titleID: LocalizedID,
      features: [FeatureItemView.Properties],
      action: (@Sendable @MainActor () -> Void)?
    ) {
      self.titleID = titleID
      self.features = features
      self.action = action
    }

    internal init(
      title: LocalizedStringID,
      @ArrayBuilder<FeatureItem> _ features: () -> [FeatureItem],
      _ action: (@Sendable @MainActor () -> Void)?
    ) {
      self.init(titleID: title, features: features(), action: action)
    }
  }

//  #Preview {
//    FeaureListView().frame(width: 600, height: 600)
//  }

#endif
