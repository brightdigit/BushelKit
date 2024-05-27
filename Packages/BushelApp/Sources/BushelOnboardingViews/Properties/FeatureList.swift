//
// FeatureList.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore

internal struct FeatureList {
  let features: [FeatureItem]

  internal init(@ArrayBuilder<FeatureItem> _ features: () -> [FeatureItem]) {
    self.init(features: features())
  }

  internal init(features: [FeatureItem]) {
    self.features = features
  }
}
