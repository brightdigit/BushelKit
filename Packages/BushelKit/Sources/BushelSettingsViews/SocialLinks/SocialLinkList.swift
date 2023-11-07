//
// SocialLinkList.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct SocialLinkList<LabelType: View>: View {
    let items: [SocialLink]
    let alignment: HorizontalAlignment
    let header: () -> LabelType
    var body: some View {
      VStack(alignment: alignment) {
        header()
        HStack {
          ForEach(items) { item in
            SocialLinkView(item)
          }
        }
      }
    }

    internal init(
      alignment: HorizontalAlignment = .trailing,
      @ViewBuilder header: @escaping () -> LabelType,
      @SocialLinkListBuilder _ items: () -> [SocialLink]
    ) {
      self.init(items: items(), alignment: alignment, header: header)
    }

    internal init(
      items: [SocialLink],
      alignment: HorizontalAlignment = .trailing,
      @ViewBuilder header: @escaping () -> LabelType
    ) {
      self.items = items
      self.alignment = alignment
      self.header = header
    }
  }

#endif
