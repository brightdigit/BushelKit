//
// Toggle.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

#if canImport(SwiftUI)
  import SwiftUI

  public typealias ToggleLabel = SwiftUI.Label<Text, Image>

  extension Toggle where Label == Text {
    public init(_ id: LocalizedStringID, isOn: Binding<Bool>) {
      self.init(isOn: isOn, label: {
        Text(id)
      })
    }
  }

  extension Toggle where Label == ToggleLabel {
    public init(_ id: LocalizedStringID, systemImage: String, isOn: Binding<Bool>) {
      self.init(isOn: isOn, label: {
        ToggleLabel(id, systemImage: systemImage)
      })
    }
  }
#endif
