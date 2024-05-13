//
// SocialLinkListBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

@resultBuilder
enum SocialLinkListBuilder {
  static func buildPartialBlock(first: SocialLink) -> [SocialLink] {
    [first]
  }

  static func buildPartialBlock(accumulated: [SocialLink], next: SocialLink) -> [SocialLink] {
    accumulated + [next]
  }
}
