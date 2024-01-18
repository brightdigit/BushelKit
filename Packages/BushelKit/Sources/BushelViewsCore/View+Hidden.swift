//
// View+Hidden.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import SwiftUI
  public extension View {
    func isHidden(_ value: Bool) -> some View {
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
