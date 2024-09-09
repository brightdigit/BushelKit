//
// RecentDocumentsObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import Combine
  import DataThespian
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
    private var typeFilter: DocumentTypeFilter? {
      willSet {
        if self.database != nil {
          Task {
            await self.invalidate()
          }
        }
      }
    }

    private var clearDate: Date? {
      willSet {
        if self.database != nil {
          Task {
            await self.invalidate()
          }
        }
      }
    }

    internal private(set) var dbPublisher: AnyPublisher<any DatabaseChangeSet, Never>
    private(set) var recentDocuments: [RecentDocument]? {
      didSet {
        self.isEmpty = self.recentDocuments?.isEmpty ?? true
      }
    }

    private(set) var isEmpty = true

    internal init(
      dbPublisher: AnyPublisher<any DatabaseChangeSet, Never> = Empty().eraseToAnyPublisher()
    ) {
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

    internal func setup(clearDate: Date?, withFilter typeFilter: DocumentTypeFilter?) {
      self.clearDate = clearDate ?? self.clearDate
      self.typeFilter = typeFilter ?? self.typeFilter

      assert(self.typeFilter != nil)
    }

    func beginPublishing<PublisherType: Publisher>(
      _ factory: @escaping () -> PublisherType
    ) where PublisherType.Failure == Never, PublisherType.Output == any DatabaseChangeSet {
      self.dbPublisher = factory().eraseToAnyPublisher()
    }

    private func invalidate() async {
      guard let database, let typeFilter else {
        assertionFailure()
        return
      }
      let clearDate = self.clearDate ?? .distantPast
      let bookmarks: [ModelID<BookmarkData>]?
      do {
        bookmarks = try await database.fetch(BookmarkData.self) {
          FetchDescriptor(typeFilter: typeFilter, clearDate: clearDate)
        }
      } catch {
        Self.logger.error("Unable to fetch bookmarks")
        bookmarks = nil
      }

      let recentDocuments: [RecentDocument]?

      if let bookmarks {
        var newRecentDocuments = [RecentDocument]()

        for bookmarkData in bookmarks {
          if let recentDocument = await RecentDocument(
            bookmarkDataID: bookmarkData,
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

  extension FetchDescriptor<BookmarkData> {
    init(typeFilter: DocumentTypeFilter, clearDate: Date) {
      let sort = \BookmarkData.updatedAt
      let order = SortOrder.reverse
      let filter: Predicate<BookmarkData>
      let searchStrings = typeFilter.searchStrings
      if let libraryFilter = searchStrings.first {
        filter = #Predicate {
          $0.updatedAt > clearDate && !$0.path.localizedStandardContains(libraryFilter)
        }
      } else {
        filter = #Predicate {
          $0.updatedAt > clearDate
        }
      }
      self.init(predicate: filter, sortBy: [.init(sort, order: order)])
    }
  }
#endif
