//
// GuidedLabeledContentDescriptionView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

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
        return true

      case (.leading, .rightToLeft):
        return true

      default:
        return false
      }
    }

    var rightSpacer: Bool {
      switch (alignment, layoutDirection) {
      case (.leading, .leftToRight):
        return true

      case (.trailing, .rightToLeft):
        return true

      default:
        return false
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
