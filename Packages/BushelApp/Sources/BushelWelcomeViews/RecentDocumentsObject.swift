//
// RecentDocumentsObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  @Observable
  final class RecentDocumentsObject: Loggable, Sendable {
    static var loggingCategory: BushelLogging.Category {
      .view
    }

    @ObservationIgnored
    private var database: (any Database)?
    private var lastUpdate: Date?
    private var bookmarks: [BookmarkData]? {
      didSet {
        Task {
          await self.invalidate()
        }
      }
    }

    private(set) var recentDocuments: [RecentDocument]? {
      didSet {
        self.isEmpty = self.recentDocuments?.isEmpty ?? true
      }
    }

    private(set) var isEmpty = true

    internal func updateBookmarks(_ bookmarks: [BookmarkData], using database: any Database) {
      self.database = database
      self.bookmarks = bookmarks
    }

    private func invalidate() async {
      guard let database else {
        assertionFailure()
        return
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
#endif
