//
// EmptyMarketListener.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct EmptyMarketListener: MarketListener {
  public static let shared: MarketListener = EmptyMarketListener()
  public func initialize(for _: BushelMarket.MarketObserver) {}

  public func invalidate() {}
}
