//
// DataInstallerImage.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData

  class DataInstallerImage: InstallerImage, LoggerCategorized {
    let entry: LibraryImageEntry
    let context: ModelContext
    let metadata: Metadata

    var libraryID: LibraryIdentifier? {
      assert(self.entry.library != nil)
      return (self.entry.library?.bookmarkDataID).map(LibraryIdentifier.bookmarkID)
    }

    var imageID: UUID {
      entry.imageID
    }

    var vmSystemID: BushelCore.VMSystemID {
      entry.vmSystemID
    }

    internal init(
      entry: LibraryImageEntry,
      context: ModelContext,
      _ labelProvider: @escaping MetadataLabelProvider
    ) {
      self.entry = entry
      self.context = context
      self.metadata = .init(entry: entry, labelProvider)
    }

    func getURL() throws -> URL {
      assert(self.entry.library != nil)
      guard let bookmarkData = self.entry.library?.bookmarkData else {
        let error = InstallerImageError(imageID: imageID, type: .missingBookmark, libraryID: libraryID)
        Self.logger.error("Unable to retrieve URL: \(error.localizedDescription)")
        assertionFailure(error: error)
        throw error
      }
      let libraryURL = try bookmarkData.fetchURL(using: context, withURL: nil)
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
        .appending(path: Paths.restoreImagesDirectoryName)
        .appending(path: imageID.uuidString)
        .appendingPathExtension(entry.fileExtension)
      return imageURL
    }
  }
#endif
