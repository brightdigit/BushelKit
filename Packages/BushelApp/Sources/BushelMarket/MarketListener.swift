//
// MarketListener.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol MarketListener: Sendable {
  func initialize(for observer: any MarketObserver)
  func invalidate()
}
