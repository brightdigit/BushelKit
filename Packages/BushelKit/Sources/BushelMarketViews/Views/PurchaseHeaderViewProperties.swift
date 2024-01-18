//
// PurchaseHeaderViewProperties.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct PurchaseHeaderViewProperties {
  static let extraLarge: Self = .init(
    logoHeight: 120,
    headerFontSize: 36.0,
    descriptionFontSize: 14.0,
    featureSpacing: 16.0,
    featureProperties: .extraLarge,
    verticalSpacing: 20,
    verticalPadding: 40,
    additionalTopPadding: 20
  )

  static let small: Self = .init(
    logoHeight: 80,
    headerFontSize: 24.0,
    descriptionFontSize: 12.0,
    featureSpacing: 8.0,
    featureProperties: .small,
    verticalSpacing: 8,
    verticalPadding: 12,
    additionalTopPadding: 8
  )

  let logoHeight: CGFloat
  let headerFontSize: CGFloat
  let descriptionFontSize: CGFloat
  let featureSpacing: CGFloat
  let feature: PurchaseFeatureViewProperties
  let verticalSpacing: CGFloat
  let verticalPadding: CGFloat
  let additionalTopPadding: CGFloat

  private init(
    logoHeight: CGFloat,
    headerFontSize: CGFloat,
    descriptionFontSize: CGFloat,
    featureSpacing: CGFloat,
    featureProperties: PurchaseFeatureViewProperties,
    verticalSpacing: CGFloat,
    verticalPadding: CGFloat,
    additionalTopPadding: CGFloat
  ) {
    self.logoHeight = logoHeight
    self.headerFontSize = headerFontSize
    self.descriptionFontSize = descriptionFontSize
    self.featureSpacing = featureSpacing
    self.feature = featureProperties
    self.verticalPadding = verticalPadding
    self.additionalTopPadding = additionalTopPadding
    self.verticalSpacing = verticalSpacing
  }
}
