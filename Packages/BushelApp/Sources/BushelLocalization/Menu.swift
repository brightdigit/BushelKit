//
// Menu.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import SwiftUI

  extension Menu where Label == Text {
    init(_ type: LocalizedStringID, @ViewBuilder content: () -> Content) {
      self.init(content: content) {
        Text(type)
      }
    }
  }
#endif
