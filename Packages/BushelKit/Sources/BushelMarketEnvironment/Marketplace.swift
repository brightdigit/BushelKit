//
// Marketplace.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import Observation

  @Observable
  public class Marketplace: LoggerCategorized, MarketObserver {
    private static var shared = [Int: Marketplace]()

    internal static let `default` = Marketplace(groupIDs: [], listener: EmptyMarketListener.shared)

    public static var loggingCategory: Loggers.Category {
      .market
    }

    public let groupIDs: [String]
    public private(set) var subscriptions: [Subscription]?
    public private(set) var error: Error?

    @ObservationIgnored
    var storeListener: (any MarketListener)?

    private init(
      groupIDs: [String],
      subscriptions: [Subscription]? = nil,
      error: Error? = nil,
      listener: @autoclosure () -> any MarketListener
    ) {
      self.groupIDs = groupIDs
      self.subscriptions = subscriptions
      self.error = error

      let storeListener = listener()
      self.storeListener = storeListener
      storeListener.initialize(for: self)
    }

    public static func createFor(
      groupIDs: [String],
      listener: @autoclosure () -> any MarketListener
    ) -> Marketplace {
      let id = Set(groupIDs).hashValue

      if let foundMarketplace = shared[id] {
        return foundMarketplace
      }

      assert(shared[id] == nil)
      assert(shared.isEmpty)

      let marketplace = Marketplace(groupIDs: groupIDs, listener: listener())
      shared[id] = marketplace
      return marketplace
    }

    public func onSubscriptionUpdate(_ result: Result<[Subscription], MarketError>) {
      switch result {
      case let .success(subscriptions):

        self.subscriptions = subscriptions
        self.error = nil
        Self.logger.debug("Successful update")

      case let .failure(.networkError(error)):
        Self.logger.debug("Subscription update network failure: \(error.localizedDescription)")

      case let .failure(error):

        self.subscriptions = nil
        self.error = error
        Self.logger.debug("Subscription update failed: \(error.localizedDescription)")
        assertionFailure(error: error)
      }
    }

    func beginUpdates() {
      assert(self.storeListener != nil)
      self.storeListener?.invalidate()
    }

    deinit {
      self.storeListener = nil
    }
  }

  public extension Marketplace {
    var subscriptionEndDate: Date? {
      self.subscriptions?.compactMap(\.renewalDate).max()
    }
  }
#endif
