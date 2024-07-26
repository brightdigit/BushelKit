//
// PageItemBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import SwiftUI

  @resultBuilder
  internal enum PageItemBuilder {
    static func viewForPage(_ page: PageType) -> any View {
      switch page {
      case let .features(features):
        FeatureListPageView(features: features)

      case let .item(item):
        PageItemView(item)
      }
    }

    static func buildPartialBlock(first: PageType) -> [any View] {
      [viewForPage(first)]
    }

    static func buildPartialBlock(accumulated: [any View], next: PageType) -> [any View] {
      accumulated + [viewForPage(next)]
    }

    static func buildArray(_ components: [PageType]) -> [any View] {
      components.map(viewForPage)
    }

    static func buildPartialBlock(first: PageItem) -> [any View] {
      [viewForPage(.item(first))]
    }

    static func buildPartialBlock(accumulated: [any View], next: PageItem) -> [any View] {
      accumulated + [viewForPage(.item(next))]
    }

    static func buildPartialBlock(first: FeatureList) -> [any View] {
      [viewForPage(.features(first.features))]
    }

    static func buildPartialBlock(accumulated: [any View], next: FeatureList) -> [any View] {
      accumulated + [viewForPage(.features(next.features))]
    }
  }
#endif
