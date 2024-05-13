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
  import Foundation
  import SwiftData

  internal final class DataInstallerImage: InstallerImage, Loggable, Sendable {
    private let entry: LibraryImageEntry
    private let database: any Database
    internal let metadata: Metadata

    internal var libraryID: LibraryIdentifier? {
      assert(self.entry.library != nil)
      return (self.entry.library?.bookmarkDataID).map(LibraryIdentifier.bookmarkID)
    }

    internal var imageID: UUID {
      entry.imageID
    }

    internal var vmSystemID: BushelCore.VMSystemID {
      entry.vmSystemID
    }

    internal init(
      entry: LibraryImageEntry,
      database: any Database,
      _ labelProvider: @escaping MetadataLabelProvider
    ) {
      self.entry = entry
      self.database = database
      self.metadata = .init(entry: entry, labelProvider)
    }

    internal func getURL() async throws -> URL {
      assert(self.entry.library != nil)
      guard let bookmarkData = self.entry.library?.bookmarkData else {
        let error = InstallerImageError(imageID: imageID, type: .missingBookmark, libraryID: libraryID)
        Self.logger.error("Unable to retrieve URL: \(error.localizedDescription)")
        assertionFailure(error: error)
        throw error
      }
      let libraryURL = try await bookmarkData.fetchURL(using: database, withURL: nil)
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
        .appendingPathExtension(entry.fileExtension)
      return imageURL
    }
  }

  extension DataInstallerImage {
    internal convenience init?(
      id: UUID,
      database: any Database,
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws {
      var imagePredicate = FetchDescriptor<LibraryImageEntry>(
        predicate: #Predicate { $0.imageID == id }
      )
      imagePredicate.fetchLimit = 1
      guard let images = try await database.fetch(imagePredicate).first else {
        return nil
      }
      guard images.library != nil else {
        return nil
      }
      self.init(entry: images, database: database, labelProvider)
    }

    internal convenience init?(
      id: UUID,
      bookmarkDataID: UUID,
      database: any Database,
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws {
      var libraryPredicate = FetchDescriptor<LibraryEntry>(
        predicate: #Predicate { $0.bookmarkDataID == bookmarkDataID }
      )

      libraryPredicate.fetchLimit = 1
      let items = try await database.fetch(libraryPredicate)
      guard let library = items.first else {
        return nil
      }
      guard let images = library.images?.first(where: { $0.imageID == id }) else {
        return nil
      }
      self.init(entry: images, database: database, labelProvider)
    }
  }
#endif