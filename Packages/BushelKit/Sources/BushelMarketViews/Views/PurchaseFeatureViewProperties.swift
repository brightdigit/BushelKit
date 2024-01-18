//
// PurchaseFeatureViewProperties.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct PurchaseFeatureViewProperties {
  static let small: Self = .init(imageWidth: 32.0, fontSize: 12.0)
  static let extraLarge: Self = .init(imageWidth: 50.0, fontSize: 16.0)

  let imageWidth: CGFloat
  let fontSize: CGFloat

  private init(imageWidth: CGFloat, fontSize: CGFloat) {
    self.imageWidth = imageWidth
    self.fontSize = fontSize
  }
}
