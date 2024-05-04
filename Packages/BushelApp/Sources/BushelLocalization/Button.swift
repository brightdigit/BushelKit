//
// Button.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public extension Button where Label == Text {
    init(role: ButtonRole? = nil, _ type: LocalizedStringID, action: @escaping () -> Void) {
      self.init(role: role, action: action) {
        Text(type)
      }
    }
  }
#endif
