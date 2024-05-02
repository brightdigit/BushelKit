//
// SliderStepperView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import Foundation
  import RadiantKit
  import SwiftUI

  public extension SliderStepperView where TitleType == LocalizedStringID, Label == Text {
    init(
      titleID: LocalizedStringID,
      value: Binding<Float>,
      bounds: ClosedRange<Float>,
      step: Float = 1.0,
      _ content: @Sendable @escaping (LocalizedStringID) -> Content
    ) {
      self.init(
        title: titleID,
        label: { titleID in
          Text(titleID)
        },
        value: value,
        bounds: bounds,
        step: step,
        content: content
      )
    }
  }
#endif
