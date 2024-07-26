//
// StoreListener.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore

  public import BushelLogging

  public import BushelMarket
  import Foundation

  public import StoreKit

  public final actor StoreListener: Loggable, MarketListener {
    public static var loggingCategory: BushelLogging.Category {
      .market
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    private var updateListener: Task<Void, Never>!
    weak var observer: (any MarketObserver)?
    var hasCurrentEntitlements = false

    public init() {}

    private static func listenerFor(_ marketplace: StoreListener) -> Task<Void, Never> {
      Task { [marketplace] in
        for await update in StoreKit.Transaction.updates {
          if let transaction = try? update.payloadValue {
            await marketplace.updateSubscriptionStatus()
            await transaction.finish()
          }
        }
      }
    }

    static func fetchSubscriptionStatus(for groupIDs: [String]) async throws -> [Subscription] {
      try await withThrowingTaskGroup(of: [Subscription].self, returning: [Subscription].self) { group in
        var subscriptions = [Subscription]()

        for groupID in groupIDs {
          group.addTask {
            try await Self.fetchSubscriptionStatus(for: groupID)
          }
        }

        for try await subscriptionSet in group {
          subscriptions.append(contentsOf: subscriptionSet)
        }
        return subscriptions
      }
    }

    static func fetchSubscriptionStatus(for groupID: String) async throws -> [Subscription] {
      logger.debug("Fetching subscription with group id \(groupID)")

      let statuses = try await Product.SubscriptionInfo.status(for: groupID)

      let renewalInfos = statuses.compactMap { status -> Product.SubscriptionInfo.RenewalInfo? in
        guard case let .verified(value) = status.renewalInfo else {
          return nil
        }
        return value
      }

      let productIDs = Set(renewalInfos.map(\.currentProductID))
      let products = try await Dictionary(grouping: Product.products(for: productIDs), by: {
        $0.id
      }).compactMapValues {
        assert($0.count == 1)
        return $0.first
      }

      return renewalInfos.map {
        Subscription(groupID: groupID, renewal: $0, products: products)
      }
    }

    public nonisolated func initialize(for observer: any MarketObserver) {
      Task {
        await self.initializeObserver(observer)
      }
    }

    private func initializeObserver(_ observer: any MarketObserver) {
      self.observer = observer
      self.updateListener = Self.listenerFor(self)

      self.invalidate()
    }

    public nonisolated func invalidate() {
      Self.logger.debug("Beginning Store Refresh")
      Task {
        await self.awaitInvalidate()
      }
    }

    private func awaitInvalidate() async {
      if !hasCurrentEntitlements {
        await self.updateCurrentEntitlements()
        self.hasCurrentEntitlements = true
      }
      await self.updateSubscriptionStatus()
    }

    private func updateSubscriptionStatus() async {
      assert(self.observer != nil)
      guard let observer else {
        return
      }
      let result = await Result {
        try await Self.fetchSubscriptionStatus(for: observer.groupIDs)
      }.mapError { error in
        guard let error = error as? StoreKitError else {
          return MarketError.unknownError(error)
        }

        guard case let .networkError(error) = error else {
          return MarketError.unknownError(error)
        }

        return MarketError.networkError(error)
      }
      observer.onSubscriptionUpdate(result)
    }

    func updateCurrentEntitlements() async {
      let sequence = Transaction.currentEntitlements.compactMap { result -> Subscription? in
        guard let transaction = try? result.payloadValue else {
          return nil
        }
        let subscription = await Subscription(transaction: transaction)
        await transaction.finish()
        return subscription
      }
      let feed = AsyncReducer(sequence: sequence)
      let subscriptions: [Subscription]
      do {
        subscriptions = try await feed.elements
      } catch {
        assertionFailure(error: error)
        Self.logger.error("Unable to get subscriptions: \(error)")
        return
      }
      observer?.onSubscriptionUpdate(.success(subscriptions))
    }

    deinit {
      self.updateListener.cancel()
      self.updateListener = nil
    }
  }

#endif
