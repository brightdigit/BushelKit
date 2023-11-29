//
// SocialLinkListHeader.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct SocialLinkListHeader: View {
    let titleID: LocalizedID
    var body: some View {
      Text(titleID).textCase(.lowercase).italic().fontWeight(.thin)
    }

    internal init(titleID: LocalizedID = LocalizedStringID.aboutSocialHeader) {
      self.titleID = titleID
    }
  }

  extension SocialLinkList where LabelType == SocialLinkListHeader {
    init(
      alignment: HorizontalAlignment = .trailing,
      @SocialLinkListBuilder _ items: () -> [SocialLink],
      headerTextID: LocalizedID = LocalizedStringID.aboutSocialHeader
    ) {
      self.init(items: items(), alignment: alignment) {
        SocialLinkListHeader(titleID: headerTextID)
      }
    }

    init(
      alignment: HorizontalAlignment = .trailing,
      headerTextID: LocalizedID = LocalizedStringID.aboutSocialHeader,
      items: [SocialLink]
    ) {
      self.init(items: items, alignment: alignment) {
        SocialLinkListHeader(titleID: headerTextID)
      }
    }
  }

#endif