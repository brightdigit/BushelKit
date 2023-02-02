//
// Menu.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  extension Menu where Label == Text {
    init(_ type: LocalizedStringID, @ViewBuilder content: () -> Content) {
      self.init(content: content) {
        Text(type)
      }
    }
  }
#endif
