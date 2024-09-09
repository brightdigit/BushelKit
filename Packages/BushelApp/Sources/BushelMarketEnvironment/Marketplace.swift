//
// Marketplace.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  public import BushelCore

  public import BushelFeatureFlags

  public import BushelLogging

  public import BushelMarket

  public import Foundation
  import Observation

  @MainActor
  @Observable
  public final class Marketplace: Loggable, MarketObserver, Sendable, UserEvaluatorComponent {
    private static var shared = [Int: Marketplace]()

    internal nonisolated static let `default` = Marketplace(
      groupIDs: [],
      listener: EmptyMarketListener.shared
    )

    public nonisolated static var loggingCategory: BushelLogging.Category {
      .market
    }

    public nonisolated static var evaluatingValue: UserAudience {
      .proSubscriber
    }

    public let groupIDs: [String]
    public private(set) var subscriptions: [Subscription]?
    public private(set) var error: (any Error)?

    @ObservationIgnored
    var storeListener: (any MarketListener)?

    private var shouldBeginUpdatesOnIntialization = false

    private nonisolated init(
      groupIDs: [String],
      listener: @autoclosure @escaping @Sendable () -> any MarketListener
    ) {
      self.groupIDs = groupIDs

      Self.logger.debug("Creating Marketplace")
      Task { @MainActor in
        let storeListener = listener()
        self.storeListener = storeListener
        storeListener.initialize(for: self)
        Self.logger.debug("Initialized StoreListener")
        if shouldBeginUpdatesOnIntialization {
          storeListener.invalidate()
        }
      }
    }

    public static func createFor(
      groupIDs: [String],
      listener: @autoclosure @Sendable @escaping () -> any MarketListener
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

    public nonisolated func onSubscriptionUpdate(_ result: Result<[Subscription], MarketError>) {
      Task { @MainActor in
        switch result {
        case let .success(subscriptions):

          self.subscriptions.merge(with: subscriptions)
          self.error = nil
          Self.logger.debug("Successful update: \(subscriptions.count)")

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
      Self.logger.debug("Beginning Updates")
      guard let storeListener else {
        self.shouldBeginUpdatesOnIntialization = true
        return
      }
      storeListener.invalidate()
    }

    public func evaluate(_: UserAudience) -> Bool {
      self.purchased
    }

    deinit {
      MainActor.assumeIsolated {
        self.storeListener = nil
      }
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
