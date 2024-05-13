//
// FeatureItemView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct FeatureItemView: View {
    typealias Properties = FeatureItem

    let properties: Properties
    var body: some View {
      HStack {
        Image(icon: properties.icon)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 40)
          .layoutPriority(1_000)
          .padding(.trailing, 4.0)
        VStack(alignment: .leading, spacing: 2.0) {
          Text(properties.titleID)
            .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
            .font(.system(size: 14.0))
          Text(properties.descriptionID)
            .font(.system(size: 12))
            .lineLimit(2, reservesSpace: true)
        }
        Spacer()
      }.padding(.vertical, 8.0)
    }
  }
#endif
