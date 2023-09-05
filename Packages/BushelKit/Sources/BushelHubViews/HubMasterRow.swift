//
// HubMasterRow.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore
  import Foundation
  import SwiftUI

  struct HubMasterRow: View {
    struct TextFieldButtonHeight: PreferenceKey {
      static let defaultValue: CGFloat = 0

      static func reduce(value: inout CGFloat,
                         nextValue: () -> CGFloat) {
        value = max(value, nextValue())
      }
    }

    @State private var textFieldButtonHeight: CGFloat?

    internal init(properties: HubMasterRow.Properties) {
      self.properties = properties
    }

    let properties: Properties

    struct Properties {
      let text: String
      let count: Int?
      let image: () -> Image
    }

    var body: some View {
      HStack {
        self.properties.image().renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(height: textFieldButtonHeight)
        Text(properties.text).background(GeometryReader { geometry in
          Color.clear.preference(
            key: TextFieldButtonHeight.self,
            value: geometry.size.height
          )
        })
        if let count = properties.count {
          Spacer()
          ValueTextBubble(value: count)
        }
      }.onPreferenceChange(TextFieldButtonHeight.self) {
        textFieldButtonHeight = $0
      }
    }
  }
#endif
