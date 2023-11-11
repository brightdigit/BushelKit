//
// FeatureList.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelViewsCore
struct FeatureList {
  let features: [FeatureItem]

  internal init(@ArrayBuilder<FeatureItem> _ features: () -> [FeatureItem]) {
    self.init(features: features())
  }

  internal init(features: [FeatureItem]) {
    self.features = features
  }
}
