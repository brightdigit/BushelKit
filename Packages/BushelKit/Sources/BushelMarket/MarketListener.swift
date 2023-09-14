//
// MarketListener.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol MarketListener {
  func initialize(for observer: MarketObserver)
  func invalidate()
}
