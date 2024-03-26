//
// MarketObserver.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation
public protocol MarketObserver: AnyObject {
  var groupIDs: [String] { get }
  func onSubscriptionUpdate(_ result: Result<[Subscription], MarketError>)
}
