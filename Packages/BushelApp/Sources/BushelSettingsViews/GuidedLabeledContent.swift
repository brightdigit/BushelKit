//
// GuidedLabeledContent.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import Foundation
  import RadiantKit
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

  extension GuidedLabeledContent {
    init(
      _ source: any LocalizedID,
      destructiveButtonTextID: any LocalizedID,
      destructiveButtonSystemName: String? = nil,
      labelTextID: any LocalizedID,
      labelImageSystemName: String? = nil,
      _ destructiveButtonAction: @escaping @Sendable @MainActor () -> Void
    )
      where Content == Button<HStack<TupleView<(Image?, Text)>>>,
      Label == HStack<TupleView<(Image?, Text)>>,
      Description == GuidedLabeledContentDescriptionView {
      self.init(source) {
        Button(
          role: .destructive,
          action: destructiveButtonAction
        ) {
          HStack {
            destructiveButtonSystemName.map {
              Image(systemName: $0)
            }
            Text(destructiveButtonTextID)
          }
        }
      } label: {
        HStack {
          labelImageSystemName.map {
            Image(systemName: $0)
          }

          Text(labelTextID)
        }
      }
    }
  }
#endif
