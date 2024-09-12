//
// DataInstallerImage.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelLogging
  import BushelMachine
  import DataThespian
  import Foundation
  import SwiftData

  internal final class DataInstallerImage: InstallerImage, Loggable, Sendable {
    private let database: any Database
    internal let metadata: Metadata

    private let fileExtension: String
    private let bookmarkDataID: UUID?
    internal var libraryID: LibraryIdentifier? {
      assert(bookmarkDataID != nil)
      return bookmarkDataID.map(LibraryIdentifier.bookmarkID)
    }

    internal let imageID: UUID

    internal let vmSystemID: BushelCore.VMSystemID

    internal init(
      entry: LibraryImageEntry,
      database: any Database,
      _ labelProvider: @escaping MetadataLabelProvider
    ) {
      self.fileExtension = entry.fileExtension
      self.bookmarkDataID = entry.library?.bookmarkDataID
      self.imageID = entry.imageID
      self.vmSystemID = entry.vmSystemID
      self.database = database
      self.metadata = .init(entry: entry, labelProvider)
    }

    internal func getURL() async throws -> URL {
      assert(bookmarkDataID != nil)
      guard let bookmarkDataID else {
        let error = InstallerImageError(imageID: imageID, type: .missingBookmark, libraryID: libraryID)
        Self.logger.error("Unable to retrieve URL: \(error.localizedDescription)")
        assertionFailure(error: error)
        throw error
      }
      let libraryURL = try await self.database.first(
        #Predicate<BookmarkData> { $0.bookmarkID == bookmarkDataID }
      ) { bookmarkData in
        try bookmarkData?.fetchURL()
      }

      guard let libraryURL else {
        let error = InstallerImageError(imageID: imageID, type: .missingBookmark, libraryID: libraryID)
        Self.logger.error("Unable to retrieve URL: \(error.localizedDescription)")
        assertionFailure(error: error)
        throw error
      }
      guard libraryURL.startAccessingSecurityScopedResource() else {
        let error = InstallerImageError(
          imageID: imageID,
          type: .accessDeniedURL(libraryURL),
          libraryID: libraryID
        )
        Self.logger.error("Unable to access URL: \(error.localizedDescription)")
        assertionFailure(error: error)
        throw error
      }
      let imageURL = libraryURL
        .appending(path: URL.bushel.paths.restoreImagesDirectoryName)
        .appending(path: imageID.uuidString)
        .appendingPathExtension(fileExtension)
      return imageURL
    }
  }

  extension DataInstallerImage {
    static func fromDatabase(
      _ database: any Database,
      withImageID id: UUID,
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> DataInstallerImage? {
      try await database.first(
        #Predicate<LibraryImageEntry> { $0.imageID == id }
      ) { imageEntry -> DataInstallerImage? in
        guard let imageEntry else {
          return nil
        }
        guard imageEntry.library == nil else {
          return nil
        }
        return .init(entry: imageEntry, database: database, labelProvider)
      }
    }

    static func fromDatabase(
      _ database: any Database,
      withImageID id: UUID,
      bookmarkDataID: UUID,
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> DataInstallerImage? {
      try await database.first(
        #Predicate<LibraryEntry> { $0.bookmarkDataID == bookmarkDataID }
      ) { libraryEntry -> DataInstallerImage? in
        guard let libraryEntry else {
          return nil
        }

        guard let imageEntry = libraryEntry.images?.first(where: { $0.imageID == id }) else {
          return nil
        }
        return .init(entry: imageEntry, database: database, labelProvider)
      }
    }
  }
#endif
