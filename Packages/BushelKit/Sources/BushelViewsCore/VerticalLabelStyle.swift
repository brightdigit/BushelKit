//
// VerticalLabelStyle.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public struct VerticalLabelStyle: LabeledContentStyle {
    public init(
      alignment: HorizontalAlignment = .leading,
      labelFont: Font = .subheadline,
      labelPaddingEdgeInsets: EdgeInsets = .init(top: 0, leading: 4.0, bottom: 0.0, trailing: 0.0)
    ) {
      self.alignment = alignment
      self.labelFont = labelFont
      self.labelPaddingEdgeInsets = labelPaddingEdgeInsets
    }

    let alignment: HorizontalAlignment
    let labelFont: Font
    let labelPaddingEdgeInsets: EdgeInsets

    public func makeBody(configuration: Configuration) -> some View {
      VStack(alignment: alignment) {
        configuration.content.labelsHidden()
        configuration.label.font(labelFont).padding(labelPaddingEdgeInsets)
      }
    }
  }

  public extension LabeledContentStyle {
    static func vertical(
      alignment: HorizontalAlignment = .leading,
      labelFont: Font = .subheadline,
      labelPaddingEdgeInsets: EdgeInsets = .init(top: 0, leading: 2.0, bottom: 0.0, trailing: 0.0)
    ) -> Self where Self == VerticalLabelStyle {
      .init(alignment: alignment, labelFont: labelFont, labelPaddingEdgeInsets: labelPaddingEdgeInsets)
    }
  }
#endif
