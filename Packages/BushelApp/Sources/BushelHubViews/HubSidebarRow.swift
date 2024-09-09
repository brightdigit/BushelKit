//
// HubSidebarRow.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore

  import Foundation

  import SwiftUI

  internal struct HubSidebarRow: View {
    internal struct Properties {
      internal let text: String
      internal let count: Int?
      internal let image: () -> Image
    }

    private let properties: Properties

    internal var body: some View {
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

    internal init(properties: HubSidebarRow.Properties) {
      self.properties = properties
    }
  }
#endif
