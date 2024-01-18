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
  class RecentDocumentsObject: Loggable {
    static var loggingCategory: BushelLogging.Category {
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

    private(set) var recentDocuments: [RecentDocument]? {
      didSet {
        self.isEmpty = self.recentDocuments?.isEmpty ?? true
      }
    }

    private(set) var isEmpty = true

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
