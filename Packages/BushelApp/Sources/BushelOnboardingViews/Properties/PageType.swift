//
// PageType.swift
// Copyright (c) 2024 BrightDigit.
//

internal enum PageType: Identifiable {
  case item(PageItem)
  case features([FeatureItem])

  var id: String {
    switch self {
    case let .features(features):
      features.map(\.id).joined()

    case let .item(item):
      item.id
    }
  }
}
