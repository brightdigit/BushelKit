//
// RecentDocumentsObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import BushelCore
  import BushelData
  import BushelDataMonitor
  import BushelLogging
  import Combine
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  @MainActor
  @Observable
  internal final class RecentDocumentsObject: Loggable, Sendable {
    nonisolated static var loggingCategory: BushelLogging.Category {
      .view
    }

    @ObservationIgnored
    private var database: (any Database)?
    private var lastUpdate: Date?
    private let typeFilter: DocumentTypeFilter
    private let clearDate: Date

    internal private(set) var dbPublisher: AnyPublisher<any DatabaseChangeSet, Never>
    private(set) var recentDocuments: [RecentDocument]? {
      didSet {
        self.isEmpty = self.recentDocuments?.isEmpty ?? true
      }
    }

    private(set) var isEmpty = true

    internal init(
      typeFilter: DocumentTypeFilter,
      clearDate: Date,
      dbPublisher: AnyPublisher<any DatabaseChangeSet, Never> = Empty().eraseToAnyPublisher()
    ) {
      self.typeFilter = typeFilter
      self.clearDate = clearDate
      self.dbPublisher = dbPublisher
    }

    internal func updateBookmarks(_ update: (any DatabaseChangeSet)?, using database: any Database) {
      self.database = database

      if update.needsBookmarkUpdate {
        Self.logger.debug("Calling Invalidate")
        Task {
          await self.invalidate()
        }
      }
    }

    func beginPublishing<PublisherType: Publisher>(
      _ factory: @escaping () -> PublisherType
    ) where PublisherType.Failure == Never, PublisherType.Output == any DatabaseChangeSet {
      self.dbPublisher = factory().eraseToAnyPublisher()
    }

    private func invalidate() async {
      guard let database else {
        assertionFailure()
        return
      }
      let bookmarks: [BookmarkData]?
      let sort = \BookmarkData.updatedAt
      let order = SortOrder.reverse
      let filter: Predicate<BookmarkData>
      let searchStrings = typeFilter.searchStrings
      Self.logger.debug("Querying for \(searchStrings)")
      if let libraryFilter = searchStrings.first {
        filter = #Predicate {
          $0.updatedAt > clearDate && !$0.path.localizedStandardContains(libraryFilter)
        }
      } else {
        filter = #Predicate {
          $0.updatedAt > clearDate
        }
      }
      do {
        bookmarks = try await database.fetch(filter, sortBy: [.init(sort, order: order)])
      } catch {
        Self.logger.error("Unable to fetch bookmarks")
        bookmarks = nil
      }
      let recentDocuments: [RecentDocument]?

      if let bookmarks {
        var newRecentDocuments = [RecentDocument]()

        for bookmarkData in bookmarks {
          if let recentDocument = await RecentDocument(
            bookmarkData: bookmarkData,
            logger: Self.logger,
            using: database
          ) {
            newRecentDocuments.append(recentDocument)
          }
        }
        recentDocuments = newRecentDocuments
      } else {
        recentDocuments = nil
      }
      Task { @MainActor in
        self.recentDocuments = recentDocuments
        self.lastUpdate = Date()
      }
    }
  }

  extension Optional where Wrapped == any DatabaseChangeSet {
    var needsBookmarkUpdate: Bool {
      guard let value = self else {
        return true
      }

      return [value.deleted, value.inserted, value.updated].contains { collection in
        collection.contains(where: { $0.entityName == "BookmarkData" })
      }
    }
  }
#endif
