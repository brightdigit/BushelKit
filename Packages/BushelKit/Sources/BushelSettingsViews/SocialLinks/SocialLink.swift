//
// SocialLink.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

struct SocialLink: Identifiable {
  let socialImageName: String
  let title: String
  let name: String
  let url: URL

  var id: URL {
    url
  }

  internal init(
    socialImageName: String,
    title: String,
    name: String,
    _ urlString: StaticString
  ) {
    self.init(
      socialImageName: socialImageName,
      title: title,
      name: name,
      url: .init(urlString)
    )
  }

  private init(
    socialImageName: String,
    title: String,
    name: String,
    url: URL
  ) {
    self.socialImageName = socialImageName
    self.title = title
    self.name = name
    self.url = url
  }
}

//  #Preview {
//    SocialLinkView()
//  }
