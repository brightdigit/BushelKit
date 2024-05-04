//
// LibraryEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore
  import BushelLibrary
  import BushelLogging
  import Foundation
  import SwiftData

  #warning("I think we need to log the operations running for this entry")
  @Model
  public final class LibraryEntry: Loggable, BookmarkedEntry, Sendable {
    public typealias BookmarkedErrorType = LibraryError

    @Attribute(.unique)
    public private(set) var bookmarkDataID: UUID

    @Transient
    private var _bookmarkData: BookmarkData?

    @Transient
    public var bookmarkData: BookmarkData? {
      if let bookmarkData = self._bookmarkData {
        return bookmarkData
      }
      let descriptor = FetchDescriptor(
        predicate: #Predicate<BookmarkData> {
          $0.bookmarkID == bookmarkDataID
        }
      )
      do {
        self._bookmarkData = try modelContext?.fetch(descriptor).first
      } catch {
        assertionFailure(error: error)
      }
      assert(self._bookmarkData != nil)
      return self._bookmarkData
    }

    @Relationship(deleteRule: .cascade, inverse: \LibraryImageEntry.library)
    public private(set) var images: [LibraryImageEntry]?

    private init(bookmarkData: BookmarkData) {
      bookmarkDataID = bookmarkData.bookmarkID
      _bookmarkData = bookmarkData
    }
  }

  public extension LibraryEntry {
    var imageCount: Int {
      self.images?.count ?? 0
    }

    convenience init(
      bookmarkData: BookmarkData,
      library: Library,
      withDatabase database: any Database
    ) async throws {
      self.init(bookmarkData: bookmarkData)
      await database.insert(self)
      try await database.save()

      for file in library.items {
        _ = try await LibraryImageEntry(library: self, file: file, using: database)
      }

      try await database.save()
    }

    func synchronizeWith(_ library: Library, using database: any Database) async throws {
      let entryMap: [UUID: LibraryImageEntry] = .init(uniqueKeysWithValues: images?.map {
        ($0.imageID, $0)
      } ?? [])

      let imageMap: [UUID: LibraryImageFile] = .init(uniqueKeysWithValues: library.items.map {
        ($0.id, $0)
      })

      let entryIDsToUpdate = Set(entryMap.keys).intersection(imageMap.keys)
      let entryIDsToDelete = Set(entryMap.keys).subtracting(imageMap.keys)
      let libraryIDsToInsert = Set(imageMap.keys).subtracting(entryMap.keys)

      let entriesToDelete = entryIDsToDelete.compactMap { entryMap[$0] }
      let libraryItemsToInsert = libraryIDsToInsert.compactMap { imageMap[$0] }

      for entryID in entryIDsToUpdate {
        guard let entry = entryMap[entryID], let images = imageMap[entryID] else {
          assertionFailure("synconized ids not found for \(entryID)")
          Self.logger.error("synconized ids not found for \(entryID)")
          return
        }
        try await entry.syncronizeFile(images, withLibrary: self, using: database)
      }

      for file in libraryItemsToInsert {
        _ = try await LibraryImageEntry(library: self, file: file, using: database)
      }

      for entry in entriesToDelete {
        await database.delete(entry)
      }

      try await database.save()
    }

    @discardableResult
    func appendImage(
      file: LibraryImageFile,
      using database: any Database
    ) async throws -> LibraryImageEntry {
      let entry = try await LibraryImageEntry(library: self, file: file, using: database)
      try await database.save()
      return entry
    }
  }
#endif
