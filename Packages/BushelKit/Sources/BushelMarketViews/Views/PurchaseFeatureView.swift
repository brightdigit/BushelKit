//
// PurchaseFeatureView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct PurchaseFeatureView: View {
    let properties: PurchaseFeatureItem

    var body: some View {
      HStack {
        Image(systemName: properties.systemName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50, alignment: .center)
          .foregroundStyle(.tint)
        VStack(alignment: .leading) {
          Text(properties.titleID)
            .font(.system(size: 16.0))
            .fontWeight(.bold)
          Text(properties.descriptionID)

            .opacity(0.8)
        }
      }
    }

    internal init(properties: PurchaseFeatureItem) {
      self.properties = properties
    }
  }

//  #Preview {
//    PurchaseFeatureView()
//  }
#endif
