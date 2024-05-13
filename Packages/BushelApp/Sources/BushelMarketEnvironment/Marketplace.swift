//
// Marketplace.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelFeatureFlags
  import BushelLogging
  import BushelMarket
  import Foundation
  import Observation

  @Observable
  public final class Marketplace: Loggable, MarketObserver, Sendable, UserEvaluatorComponent {
    private static var shared = [Int: Marketplace]()

    internal static let `default` = Marketplace(groupIDs: [], listener: EmptyMarketListener.shared)

    public static var loggingCategory: BushelLogging.Category {
      .market
    }

    public static var evaluatingValue: UserAudience {
      .proSubscriber
    }

    public let groupIDs: [String]
    public private(set) var subscriptions: [Subscription]?
    public private(set) var error: (any Error)?

    @ObservationIgnored
    var storeListener: (any MarketListener)?

    private init(
      groupIDs: [String],
      subscriptions: [Subscription]? = nil,
      error: (any Error)? = nil,
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

      UserEvaluator.register(marketplace)
      shared[id] = marketplace
      return marketplace
    }

    public func onSubscriptionUpdate(_ result: Result<[Subscription], MarketError>) {
      Task { @MainActor in
        switch result {
        case let .success(subscriptions):

          self.subscriptions.merge(with: subscriptions)
          self.error = nil
          Self.logger.debug("Successful update")

        case let .failure(.networkError(error)):
          Self.logger.debug("Subscription update network failure: \(error.localizedDescription)")

        case let .failure(error):

          self.error = error
          Self.logger.debug("Subscription update failed: \(error.localizedDescription)")
          assertionFailure(error: error)
        }
      }
    }

    func beginUpdates() {
      assert(self.storeListener != nil)
      self.storeListener?.invalidate()
    }

    public func evaluate(_: UserAudience) -> Bool {
      self.purchased
    }

    deinit {
      self.storeListener = nil
    }
  }

  extension Marketplace {
    public var subscriptionEndDate: Date? {
      self.subscriptions?.compactMap(\.renewalDate).max()
    }

    public var purchased: Bool {
      guard let subscriptionEndDate else {
        return false
      }
      return subscriptionEndDate > Date()
    }
  }
#endif