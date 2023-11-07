//
// PurchaseHeaderView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct PurchaseHeaderView: View {
    let features: [PurchaseFeatureItem]

    var body: some View {
      PreferredLayoutView { value in
        VStack(spacing: 20) {
          Image.resource("Logo").resizable().aspectRatio(contentMode: .fit).frame(height: 120)

          Text(.welcomeToBushel)
            .font(.system(size: 36.0))
            .fontWeight(.bold)

          Text(.purchaseDescription)
            .font(.system(size: 14.0))
            .multilineTextAlignment(.leading)
            .lineLimit(3, reservesSpace: true)
            .apply(\.size.width, with: value)
            .padding(.horizontal, 40)

          HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 16.0) {
              ForEach(self.features) { properties in
                PurchaseFeatureView(properties: properties)
              }
            }.padding(8.0).frame(width: value.get(), alignment: .leading)
            Spacer()
          }
        }
      }.padding(40)
        .padding(.top, 20)
    }

    internal init(features: [PurchaseFeatureItem]) {
      self.features = features
    }

    internal init(@ArrayBuilder<PurchaseFeatureItem> _ features: () -> [PurchaseFeatureItem]) {
      self.init(features: features())
    }
  }

#endif
