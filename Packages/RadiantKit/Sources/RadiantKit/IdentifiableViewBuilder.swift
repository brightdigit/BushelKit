//
// IdentifiableViewBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  @MainActor
  @resultBuilder
  public enum IdentifiableViewBuilder {
    public static func buildPartialBlock(first: any View) -> [IdentifiableView] {
      [IdentifiableView(first, id: 0)]
    }

    public static func buildPartialBlock(
      accumulated: [IdentifiableView],
      next: any View
    ) -> [IdentifiableView] {
      accumulated + [IdentifiableView(next, id: accumulated.count)]
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
