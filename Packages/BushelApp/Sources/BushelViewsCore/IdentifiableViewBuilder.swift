//
// IdentifiableViewBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import Foundation

  public import SwiftUI

  @available(*, unavailable, message: "Use RadiantKit.")
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
