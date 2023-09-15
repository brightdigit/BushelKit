//
// WelcomeRecentDocumentsObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import Foundation
  import Observation
  import SwiftData

  @Observable
  class WelcomeRecentDocumentsObject: LoggerCategorized {
    static var loggingCategory: Loggers.Category {
      .view
    }

    @ObservationIgnored
    private var context: ModelContext?
    private var lastUpdate: Date?
    private var bookmarks: [BookmarkData]? {
      didSet {
        self.invalidate()
      }
    }

    private(set) var recentDocuments: [RecentDocument]?

    internal func updateBookmarks(_ bookmarks: [BookmarkData], using context: ModelContext) {
      self.context = context
      self.bookmarks = bookmarks
    }

    private func invalidate() {
      guard let context else {
        assertionFailure()
        return
      }
      self.recentDocuments = self.bookmarks?.compactMap { bookmarkData in
        RecentDocument(bookmarkData: bookmarkData, logger: Self.logger, using: context)
      }
      self.lastUpdate = Date()
    }
  }
#endif