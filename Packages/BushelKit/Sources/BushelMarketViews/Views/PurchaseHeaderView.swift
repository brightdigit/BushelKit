//
// PurchaseHeaderView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct PurchaseHeaderView: View {
    typealias Properties = PurchaseHeaderViewProperties

    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    let properties: Properties
    let features: [PurchaseFeatureItem]

    var body: some View {
      PreferredLayoutView { value in
        VStack(spacing: properties.verticalSpacing) {
          Image.resource("Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: properties.logoHeight)

          Text(.bushel)
            .font(.system(size: properties.headerFontSize))
            .fontWeight(.bold)

          Text(.purchaseDescription)
            .font(.system(size: properties.descriptionFontSize))
            .multilineTextAlignment(.leading)
            .lineLimit(3, reservesSpace: true)
            .apply(\.size.width, with: value)
            .padding(.horizontal, properties.verticalPadding)

          HStack {
            Spacer()
            VStack(alignment: .leading, spacing: properties.featureSpacing) {
              ForEach(self.features) { item in
                PurchaseFeatureView(properties: self.properties.feature, item: item)
              }
            }.padding(8.0).frame(width: value.get(), alignment: .leading)
            Spacer()
          }
        }
      }
      .padding(.horizontal, 80)
      .padding(.vertical, properties.verticalPadding)
      .padding(.top, properties.additionalTopPadding)

      .containerBackground(for: .subscriptionStoreFullHeight, content: {
        Image.resource("UI/apple-basket-bokeh").opacity(self.colorSchemeContrast == .increased ? 0.25 : 0.9)
      })
    }

    internal init(properties: Properties, features: [PurchaseFeatureItem]) {
      self.properties = properties
      self.features = features
    }

    internal init(
      properties: Properties,
      @ArrayBuilder<PurchaseFeatureItem> _ features: () -> [PurchaseFeatureItem]
    ) {
      self.init(properties: properties, features: features())
    }
  }

#endif
