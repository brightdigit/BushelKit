//
// AboutBrandView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct AboutBrandView: View {
    @Environment(\.openURL) var openURL
    let creditsHeaderID: LocalizedID
    let wordmarkImageResourceName: String
    let websiteURL: URL
    let links: [SocialLink]

    var body: some View {
      HStack(alignment: .bottom) {
        Button(openURL, self.websiteURL) {
          PreferredLayoutView { value in
            VStack(alignment: .leading) {
              Text(self.creditsHeaderID)
                .fontWeight(.thin)
                .textCase(.lowercase)
                .italic()
                .padding(.trailing, 40.0)
                .apply(\.size.width, with: value)
              Image
                .resource(self.wordmarkImageResourceName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: value.get())
            }
          }
        }
        .foregroundStyle(Color.primary)

        Spacer()
        SocialLinkList(items: links)
      }
    }

    internal init(
      creditsHeaderID: LocalizedID,
      wordmarkImageResourceName: String,
      websiteURL: URL,
      links: [SocialLink]
    ) {
      self.creditsHeaderID = creditsHeaderID
      self.wordmarkImageResourceName = wordmarkImageResourceName
      self.websiteURL = websiteURL
      self.links = links
    }

    internal init(
      creditsHeaderID: LocalizedID = LocalizedStringID.aboutSocialHeader,
      wordmarkImageResourceName: String = "BrightDigit/Wordmark/template",
      websiteURL: URL,
      @SocialLinkListBuilder _ links: () -> [SocialLink]
    ) {
      self.init(
        creditsHeaderID: creditsHeaderID,
        wordmarkImageResourceName: wordmarkImageResourceName,
        websiteURL: websiteURL,
        links: links()
      )
    }
  }
#endif
