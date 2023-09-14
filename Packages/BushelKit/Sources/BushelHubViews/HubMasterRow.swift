//
// HubMasterRow.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore
  import Foundation
  import SwiftUI

  struct HubMasterRow: View {
    struct Properties {
      let text: String
      let count: Int?
      let image: () -> Image
    }

    let properties: Properties

    var body: some View {
      PreferredLayoutView { value in
        HStack {
          self
            .properties
            .image()
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: value.get())
          Text(properties.text).apply(\.size.height, with: value)
          if let count = properties.count {
            Spacer()
            ValueTextBubble(value: count)
          }
        }
      }
    }

    internal init(
      text: String,
      count: Int?,
      image: @escaping () -> Image
    ) {
      self.init(properties: .init(text: text, count: count, image: image))
    }

    internal init(properties: HubMasterRow.Properties) {
      self.properties = properties
    }
  }
#endif
