//
// Toggle.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

#if canImport(SwiftUI)
  import SwiftUI

  public typealias ToggleLabel = SwiftUI.Label<Text, Image>

  public extension Toggle where Label == Text {
    init(_ id: LocalizedStringID, isOn: Binding<Bool>) {
      self.init(isOn: isOn, label: {
        Text(id)
      })
    }
  }

  public extension Toggle where Label == ToggleLabel {
    init(_ id: LocalizedStringID, systemImage: String, isOn: Binding<Bool>) {
      self.init(isOn: isOn, label: {
        ToggleLabel(id, systemImage: systemImage)
      })
    }
  }
#endif
