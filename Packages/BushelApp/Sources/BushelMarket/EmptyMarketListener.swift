//
// EmptyMarketListener.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct EmptyMarketListener: MarketListener, Sendable {
  public static let shared: any MarketListener = EmptyMarketListener()
  public func initialize(for _: any MarketObserver) {}

  public func invalidate() {}
}
