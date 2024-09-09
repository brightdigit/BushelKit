//
// LibraryEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore

  public import DataThespian

  public import BushelDataCore

  public import BushelLibrary

  public import BushelLogging

  public import Foundation

  public import SwiftData

  #warning("I think we need to log the operations running for this entry")
  @Model
  public final class LibraryEntry: Loggable {
    public init(bookmarkDataID: UUID) {
      self.bookmarkDataID = bookmarkDataID
    }

    public typealias BookmarkedErrorType = LibraryError

    @Attribute(.unique)
    public private(set) var bookmarkDataID: UUID

    @Relationship(deleteRule: .cascade, inverse: \LibraryImageEntry.library)
    public private(set) var images: [LibraryImageEntry]?
  }

  extension LibraryEntry {
    public var imageCount: Int {
      self.images?.count ?? 0
    }

    public struct SyncronizationDifference: Sendable {
      public let model: ModelID<LibraryEntry>

      public let imagesToInsert: [LibraryImageFile]
      public let imageModelsToDelete: [ModelID<LibraryImageEntry>]
      public let imagesToUpdate: [LibraryImageFile]
    }

    private static func syncronize(_ diff: SyncronizationDifference, using database: any Database) async throws -> ModelID<LibraryEntry> {
      try await withThrowingTaskGroup(of: Void.self) { group in
        group.addTask {
          // update images
          try await withThrowingTaskGroup(of: Void.self) { updateGroup in
            for image in diff.imagesToUpdate {
              updateGroup.addTask {
                try await database.fetch {
                  FetchDescriptor(predicate: #Predicate<LibraryImageEntry> { $0.imageID == image.id })
                } _: {
                  FetchDescriptor(model: diff.model)
                } with: { imageEntries, libraryEntries in
                  guard let imageEntry = imageEntries.first, let libraryEntry = libraryEntries.first else {
                    assertionFailure("synconized ids not found for \(image.id)")
                    Self.logger.error("synconized ids not found for \(image.id)")
                    return
                  }
                  imageEntry.syncronizeFile(image)
                  imageEntry.library = libraryEntry
                }
              }
            }
            try await updateGroup.waitForAll()
          }
        }

        group.addTask {
          try await withThrowingTaskGroup(of: Void.self) { insertGroup in
            for image in diff.imagesToInsert {
              insertGroup.addTask {
                let imageModel: ModelID = await database.insert {
                  LibraryImageEntry(file: image)
                }
                try await database.fetch {
                  FetchDescriptor(model: imageModel)
                } _: {
                  FetchDescriptor(model: diff.model)
                } with: { imageEntries, libraryEntries in
                  guard let imageEntry = imageEntries.first, let libraryEntry = libraryEntries.first else {
                    assertionFailure("synconized ids not found for \(image.id)")
                    Self.logger.error("synconized ids not found for \(image.id)")
                    return
                  }
                  imageEntry.library = libraryEntry
                }
              }
            }
            try await insertGroup.waitForAll()
          }
        }

        group.addTask {
          await withTaskGroup(of: Void.self) { deleteGroup in
            for image in diff.imageModelsToDelete {
              deleteGroup.addTask {
                await database.delete(image)
              }
            }
            await deleteGroup.waitForAll()
          }
        }
        try await group.waitForAll()
        return diff.model
      }
    }

    @discardableResult
    public static func syncronizeModel(_ model: ModelID<LibraryEntry>, with library: Library, using database: any Database) async throws -> ModelID<LibraryEntry> {
      let diff = try await database.with(model) { libraryEntry in
        libraryEntry.syncronizationReport(library)
      }

      return try await Self.syncronize(diff, using: database)
    }

    public func syncronizeWith(_ library: Library, using database: any Database) async throws -> ModelID<LibraryEntry> {
      let model = ModelID(self)
      return try await Self.syncronizeModel(model, with: library, using: database)
    }

    public func syncronizationReport(_ library: Library) -> SyncronizationDifference {
      let entryMap: [UUID: LibraryImageEntry] = .init(uniqueKeysWithValues: images?.map {
        ($0.imageID, $0)
      } ?? [])

      let imageMap: [UUID: LibraryImageFile] = .init(uniqueKeysWithValues: library.items.map {
        ($0.id, $0)
      })

      let entryIDsToUpdate = Set(entryMap.keys).intersection(imageMap.keys)
      let entryIDsToDelete = Set(entryMap.keys).subtracting(imageMap.keys)
      let libraryIDsToInsert = Set(imageMap.keys).subtracting(entryMap.keys)

      let entriesToDelete = entryIDsToDelete.compactMap { entryMap[$0] }.map(ModelID.init)
      let libraryItemsToInsert = libraryIDsToInsert.compactMap { imageMap[$0] }
      let imagesToUpdate = entryIDsToUpdate.compactMap {
        imageMap[$0]
      }

      assert(entryIDsToUpdate.count == imagesToUpdate.count)
      assert(entryIDsToDelete.count == entriesToDelete.count)
      assert(libraryItemsToInsert.count == libraryIDsToInsert.count)

      return .init(
        model: .init(self),
        imagesToInsert: libraryItemsToInsert,
        imageModelsToDelete: entriesToDelete,
        imagesToUpdate: imagesToUpdate
      )
    }
  }
#endif
