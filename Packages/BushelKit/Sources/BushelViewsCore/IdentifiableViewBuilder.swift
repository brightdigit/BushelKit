//
// IdentifiableViewBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  @resultBuilder
  public enum IdentifiableViewBuilder {
    public static func buildPartialBlock(first: any View) -> [IdentifiableView] {
      [IdentifiableView(first)]
    }

    public static func buildPartialBlock(
      accumulated: [IdentifiableView],
      next: any View
    ) -> [IdentifiableView] {
      accumulated + [IdentifiableView(next)]
    }

    public static func buildPartialBlock(first: IdentifiableView) -> [IdentifiableView] {
      [first]
    }

    public static func buildPartialBlock(
      accumulated: [IdentifiableView],
      next: IdentifiableView
    ) -> [IdentifiableView] {
      accumulated + [next]
    }
  }
#endif
