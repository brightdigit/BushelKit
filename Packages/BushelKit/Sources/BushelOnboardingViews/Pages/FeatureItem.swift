//
// FeatureItem.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct FeatureItem: View {
    let systemName: String
    let title: String
    let description: String
    var body: some View {
      HStack {
        Image(systemName: systemName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 40)
          .foregroundStyle(.tint)
        VStack(alignment: .leading) {
          Text(title).font(.title3).fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
          Text(description).font(.title3).opacity(0.8)
        }
      }.padding(.vertical, 10.0)
    }
  }
#endif
