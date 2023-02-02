//
// Button.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  extension Button where Label == Text {
    init(_ type: LocalizedStringID, action: @escaping () -> Void) {
      self.init(action: action) {
        Text(type)
      }
    }
  }
#endif
