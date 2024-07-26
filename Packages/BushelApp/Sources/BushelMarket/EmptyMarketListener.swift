//
// EmptyMarketListener.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public struct EmptyMarketListener: MarketListener, Sendable {
  public static let shared: any (MarketListener & Sendable) = EmptyMarketListener()
  public func initialize(for _: any MarketObserver) {}

  public func invalidate() {}
}
