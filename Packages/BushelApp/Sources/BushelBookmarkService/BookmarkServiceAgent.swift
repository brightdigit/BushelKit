//
// BookmarkServiceAgent.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import BushelDataCore

  public import BushelDataMonitor

  public import BushelLogging

  public import Foundation
  import SwiftData

  public actor BookmarkServiceAgent: DataAgent, Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }

    public let agentID: UUID = .init()
    let database: any Database
    var monitoringBookmarks = [PersistentIdentifier: BookmarkEventMetadata]()

    internal init(database: any Database) {
      Self.logger.debug("Creating Bookmark Service")
      self.database = database
      Task {
        try await self.initialize()
      }
    }

    private static func dispatchSourceMap(
      for bookmarks: [BookmarkData],
      from database: any Database
    ) async throws -> [BookmarkEventMetadata] {
      let urlMap = try await BookmarkData.fetchURLs(
        from: bookmarks,
        using: database,
        keyBy: { $0.persistentModelID }
      )

      return urlMap.compactMap { id, url -> (BookmarkEventMetadata)? in
        BookmarkEventMetadata(id: id, url: url)
      }
    }

    private static func dispatchSourceMap(
      forIDs ids: [PersistentIdentifier],
      from database: any Database
    ) async throws -> [BookmarkEventMetadata] {
      let newBookmarks: [BookmarkData] = try await database.fetch {
        FetchDescriptor(
          predicate:
          #Predicate<BookmarkData> {
            ids.contains($0.persistentModelID)
          }
        )
      }

      return try await Self.dispatchSourceMap(for: newBookmarks, from: database)
    }

    func initialize() async throws {
      let bookmarks: [BookmarkData] = try await database.fetch { FetchDescriptor() }
      let sources = try await Self.dispatchSourceMap(for: bookmarks, from: database)
      await self.addEntries(sources)
    }

    private func updateDatabase(basedOn metadata: BookmarkEventMetadata) async throws {
      let event = await metadata.event
      let url = metadata.url
      let persistentModelID = metadata.id
      Self.logger.debug("Updating Database for \(persistentModelID.id.hashValue)")
      let bookmark: BookmarkData? = try await database.existingModel(for: persistentModelID)
      assert(bookmark != nil)
      guard let bookmark else {
        Self.logger.error("Missing Bookmark at: \(url)")
        return
      }
      switch event {
      case .delete:
        Self.logger.debug("Deleting Bookmark from \(url)")
        await database.delete(bookmark)
        try await database.save()
      case .rename:
        Self.logger.debug("Updating Bookmark from \(url)")
        let newURL = try await bookmark.fetchURL(using: database)
        Self.logger.debug("Updated Bookmark from \(url) to \(newURL)")
      case .none:
        assert(event != nil)
      case let .unknown(rawValue):
        assertionFailure("Unknown event type from raw value: \(rawValue)")
      }
      Self.logger.debug("Update Database complete.")
    }

    private nonisolated func onObjectEvent(_ metadata: BookmarkEventMetadata) {
      Task {
        Self.logger.debug("Metadata for \(metadata.url)")
        try await self.updateDatabase(basedOn: metadata)
      }
    }

    private func removeOldBookmarks(_ removingBookmarks: [PersistentIdentifier]) async throws {
      let cancellingSources = removingBookmarks.compactMap { persistentIdentifier in
        let source = self.monitoringBookmarks.removeValue(forKey: persistentIdentifier)
        assert(source != nil)
        return source
      }
      await withTaskGroup(of: Void.self) { group in
        for source in cancellingSources {
          group.addTask {
            await source.cancel()
          }
        }
      }
    }

    public nonisolated func onUpdate(_ update: any DatabaseChangeSet) {
      Self.logger.debug("Database update received.")

      let deletedIDs = update.deleted
        .filter { $0.entityName == "BookmarkData" }
        .map(\.persistentIdentifier)
      let insertedIDs = update.inserted
        .filter { $0.entityName == "BookmarkData" }
        .map(\.persistentIdentifier)

      Task {
        await removeMonitors(withIDs: deletedIDs)
        try await addMonitors(withIDs: insertedIDs)
      }
    }

    private func addEntries(_ newEntries: [BookmarkEventMetadata]) async {
      for entry in newEntries {
        if self.monitoringBookmarks[entry.id]?.url == entry.url {
          continue
        }
        assert(self.monitoringBookmarks[entry.id] == nil)
        await entry.setEventHandler { metadata in
          self.onObjectEvent(metadata)
        }
        self.monitoringBookmarks[entry.id] = entry
      }
    }

    func addMonitors(withIDs ids: [PersistentIdentifier]) async throws {
      let newEntries = try await Self.dispatchSourceMap(forIDs: ids, from: self.database)
      assert(newEntries.count == ids.count)
      await addEntries(newEntries)
    }

    func removeMonitors(withIDs ids: [PersistentIdentifier]) {
      for id in ids {
        // assert(self.monitoringBookmarks[id] != nil)
        self.monitoringBookmarks.removeValue(forKey: id)
      }
    }

    public func finish() {
      self.monitoringBookmarks.removeAll()
    }

    deinit {
      for bookmarks in self.monitoringBookmarks {
        Task {
          await bookmarks.value.cancel()
        }
      }
    }
  }
#endif
