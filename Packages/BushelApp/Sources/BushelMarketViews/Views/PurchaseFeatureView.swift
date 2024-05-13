//
// PurchaseFeatureView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct PurchaseFeatureView: View {
    typealias Properties = PurchaseFeatureViewProperties

    let properties: Properties
    let item: PurchaseFeatureItem

    var body: some View {
      HStack {
        Image(systemName: item.systemName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: properties.imageWidth, alignment: .center)
          .foregroundStyle(.tint)
        VStack(alignment: .leading) {
          Text(.key(item.titleID))
            .font(.system(size: properties.fontSize))
            .fontWeight(.bold)
          Text(.key(item.descriptionID))
            .opacity(0.8)
        }
      }
    }

    internal init(properties: PurchaseFeatureView.Properties, item: PurchaseFeatureItem) {
      self.properties = properties
      self.item = item
    }
  }

//  #Preview {
//    PurchaseFeatureView()
//  }
#endif
