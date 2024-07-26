//
// GuidedLabeledContent.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelViewsCore
  import Foundation
  import SwiftUI

  extension GuidedLabeledContent where Description == GuidedLabeledContentDescriptionView {
    internal init(
      _ source: any LocalizedID,
      _ content: @escaping () -> Content,
      label: @escaping () -> Label,
      descriptionAlignment: GuidedLabeledContentDescriptionView.Alignment? = .leading
    ) {
      self.init(
        content,
        label: label,
        text: { Text(source) },
        descriptionAlignment: descriptionAlignment
      )
    }
  }
#endif
