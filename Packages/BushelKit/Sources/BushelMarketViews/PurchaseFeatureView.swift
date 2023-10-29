//
// PurchaseFeatureView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct PurchaseFeatureView: View {
    #warning("replace with Localized strings")
    let systemName: String
    let title: String
    let description: String

    var body: some View {
      HStack {
        Image(systemName: systemName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20)
          .foregroundStyle(.tint)
        VStack(alignment: .leading) {
          Text(title).font(.callout).fontWeight(.bold)
          Text(description).font(.caption).opacity(0.8)
        }
      }
    }
  }

//  #Preview {
//    PurchaseFeatureView()
//  }
#endif
