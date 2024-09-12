//
// BookmarkServiceAgent.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import DataThespian

  public import BushelLogging

  public import Foundation
  import class BushelDataCore.BookmarkData
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

    func initialize() async throws {
      let sources = try await database.fetch(BookmarkData.self) {
        try $0.map {
          try BookmarkEventMetadata(id: $0.persistentModelID, url: $0.fetchURL())
        }
        .compactMap { $0 }
      }

      await self.addEntries(sources)
    }

    private func updateDatabase(basedOn metadata: BookmarkEventMetadata) async throws {
      let event = await metadata.event
      let url = metadata.url
      let persistentModelID = metadata.id
      Self.logger.debug("Updating Database for \(persistentModelID.id.hashValue)")

      let shouldDelete: Bool = try await database.get(
        of: BookmarkData.self,
        for: persistentModelID
      ) { bookmark -> Bool in
        assert(bookmark != nil)
        guard let bookmark else {
          Self.logger.error("Missing Bookmark at: \(url)")
          return false
        }
        switch event {
        case .delete:
          Self.logger.debug("Deleting Bookmark from \(url)")
          return true
        case .rename:
          Self.logger.debug("Updating Bookmark from \(url)")
          let newURL = try bookmark.fetchURL()
          Self.logger.debug("Updated Bookmark from \(url) to \(newURL)")
        case .none:
          assert(event != nil)
        case let .unknown(rawValue):
          assertionFailure("Unknown event type from raw value: \(rawValue)")
        }
        return false
      }

      if shouldDelete {
        await database.delete(BookmarkData.self, withID: persistentModelID)
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
      let newEntries = try await database.fetch(of: BookmarkData.self, for: ids) {
        try BookmarkEventMetadata(id: $0.persistentModelID, url: $0.fetchURL())
      }
      .compactMap { $0 }
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
