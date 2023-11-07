//
// Button.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public extension Button {
    init(_ openURL: OpenURLAction, _ url: URL, @ViewBuilder _ label: () -> Label) {
      self.init(action: {
        openURL.callAsFunction(url)
      }, label: label)
    }

    init(_ titleKey: LocalizedStringKey, _ openURL: OpenURLAction, _ url: URL) where Label == Text {
      self.init(openURL, url) {
        Text(titleKey)
      }
    }
  }
#endif
