//
// View+Hidden.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  public import SwiftUI

  extension View {
    public func isHidden(_ value: Bool) -> some View {
      Group {
        if value {
          self.hidden()
        } else {
          self
        }
      }
    }
  }
#endif
