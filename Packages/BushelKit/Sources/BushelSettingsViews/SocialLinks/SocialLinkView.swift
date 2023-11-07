//
// SocialLinkView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore
  import SwiftUI

  struct SocialLinkView: View {
    @Environment(\.openURL) var openURL
    let imageName: String
    let title: String
    let name: String
    let url: URL
    var body: some View {
      Button {
        openURL(url)
      } label: {
        PreferredLayoutView { value in
          Group {
            Image.resource(imageName)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: value.get())
            Text(title)
              .font(.system(size: 12.0))
              .fontWeight(.thin)
              .lineLimit(1)
              .apply(\.size.height, with: value)
          }
        }
      }
      #if os(macOS)
      .buttonStyle(.link)
      #endif
    }

    internal init(imageName: String, title: String, name: String, url: URL) {
      self.imageName = imageName
      self.title = title
      self.name = name
      self.url = url
    }
  }

  extension SocialLinkView {
    init(_ link: SocialLink) {
      self.init(
        imageName: [
          "Social",
          link.socialImageName
        ]
        .joined(separator: "/"),
        title: link.title,
        name: link.name,
        url: link.url
      )
    }
  }

//  #Preview {
//    SocialLinkView()
//  }
#endif
