//
// GuidedLabeledContent.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelViewsCore
  import Foundation
  import SwiftUI

  public extension GuidedLabeledContent where Description == GuidedLabeledContentDescriptionView {
    init(
      _ source: LocalizedID,
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
