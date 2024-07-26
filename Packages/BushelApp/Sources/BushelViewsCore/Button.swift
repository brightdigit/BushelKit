//
// Button.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import SwiftUI

  extension Button {
    public init(_ openURL: OpenURLAction, _ url: URL, @ViewBuilder _ label: () -> Label) {
      self.init(action: {
        openURL.callAsFunction(url)
      }, label: label)
    }

    public init(_ titleKey: LocalizedStringKey, _ openURL: OpenURLAction, _ url: URL) where Label == Text {
      self.init(openURL, url) {
        Text(titleKey)
      }
    }
  }
#endif
