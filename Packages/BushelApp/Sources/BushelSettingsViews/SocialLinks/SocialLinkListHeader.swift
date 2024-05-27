//
// SocialLinkListHeader.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  internal struct SocialLinkListHeader: View {
    let titleID: any LocalizedID
    var body: some View {
      Text(titleID).textCase(.lowercase).italic().fontWeight(.thin)
    }

    internal init(titleID: any LocalizedID = LocalizedStringID.aboutSocialHeader) {
      self.titleID = titleID
    }
  }

  extension SocialLinkList where LabelType == SocialLinkListHeader {
    init(
      alignment: HorizontalAlignment = .trailing,
      @SocialLinkListBuilder _ items: () -> [SocialLink],
      headerTextID: any LocalizedID = LocalizedStringID.aboutSocialHeader
    ) {
      self.init(items: items(), alignment: alignment) {
        SocialLinkListHeader(titleID: headerTextID)
      }
    }

    init(
      alignment: HorizontalAlignment = .trailing,
      headerTextID: any LocalizedID = LocalizedStringID.aboutSocialHeader,
      items: [SocialLink]
    ) {
      self.init(items: items, alignment: alignment) {
        SocialLinkListHeader(titleID: headerTextID)
      }
    }
  }

#endif
