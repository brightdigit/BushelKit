//
// GuidedLabeledContentDescriptionView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import SwiftUI

  public struct GuidedLabeledContentDescriptionView: View {
    public enum Alignment {
      case leading
      case trailing
    }

    @Environment(\.layoutDirection) var layoutDirection
    let text: () -> Text
    let alignment: Alignment?

    var multilineTextAlignment: TextAlignment {
      switch alignment {
      case .leading:
        .leading

      case .trailing:
        .trailing

      case nil:
        .center
      }
    }

    var leftSpacer: Bool {
      switch (alignment, layoutDirection) {
      case (.trailing, .leftToRight):
        true

      case (.leading, .rightToLeft):
        true

      default:
        false
      }
    }

    var rightSpacer: Bool {
      switch (alignment, layoutDirection) {
      case (.leading, .leftToRight):
        true

      case (.trailing, .rightToLeft):
        true

      default:
        false
      }
    }

    public var body: some View {
      HStack {
        if leftSpacer {
          Spacer()
        }
        text().font(.callout).multilineTextAlignment(self.multilineTextAlignment)

        if rightSpacer {
          Spacer()
        }
      }
    }

    internal init(alignment: Alignment? = nil, text: @escaping () -> Text) {
      self.text = text
      self.alignment = alignment
    }
  }
#endif
