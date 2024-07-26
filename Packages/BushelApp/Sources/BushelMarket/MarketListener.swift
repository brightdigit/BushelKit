//
// MarketListener.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public protocol MarketListener {
  func initialize(for observer: any MarketObserver)
  func invalidate()
}
