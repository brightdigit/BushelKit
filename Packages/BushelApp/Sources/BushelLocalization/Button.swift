//
// Button.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import SwiftUI

  extension Button where Label == Text {
    public init(role: ButtonRole? = nil, _ type: LocalizedStringID, action: @escaping () -> Void) {
      self.init(role: role, action: action) {
        Text(type)
      }
    }
  }
#endif
