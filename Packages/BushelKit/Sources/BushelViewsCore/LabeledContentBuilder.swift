//
// LabeledContentBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  @resultBuilder
  public enum LabeledContentBuilder {
    public static func buildPartialBlock(
      first: LabeledContent<some View, some View>
    ) -> [IdentifiableView] {
      [
        IdentifiableView(
          first
            .labeledContentStyle(
              .vertical()
            )
        )
      ]
    }

    public static func buildPartialBlock(
      accumulated: [IdentifiableView],
      next: LabeledContent<some View, some View>
    ) -> [IdentifiableView] {
      accumulated + [IdentifiableView(next.labeledContentStyle(.vertical()))]
    }
  }
#endif
