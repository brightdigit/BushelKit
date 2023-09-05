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
    internal init(entry: LibraryImageEntry, context: ModelContext, _ labelProvider: @escaping (VMSystemID, ImageMetadata) -> MetadataLabel) {
      self.entry = entry
      self.context = context
      self.metadata = .init(entry: entry, labelProvider)
    }

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

    var vmSystem: BushelCore.VMSystemID {
      entry.vmSystem
    }

    func getURL() throws -> URL {
      assert(self.entry.library != nil)
      guard let bookmarkData = self.entry.library?.bookmarkData else {
        let error = InstallerImageError(imageID: imageID, libraryID: libraryID, type: .missingBookmark)
        Self.logger.error("Unable to retrieve URL: \(error.localizedDescription)")
        assertionFailure(error: error)
        throw error
      }
      let libraryURL = try bookmarkData.fetchURL(using: context, withURL: nil)
      guard libraryURL.startAccessingSecurityScopedResource() else {
        let error = InstallerImageError(imageID: imageID, libraryID: libraryID, type: .accessDeniedURL(libraryURL))
        Self.logger.error("Unable to access URL: \(error.localizedDescription)")
        assertionFailure(error: error)
        throw error
      }
      let imageURL = libraryURL.appending(path: Paths.restoreImagesDirectoryName).appending(path: imageID.uuidString).appendingPathExtension(entry.fileExtension)
      return imageURL
    }
  }
#endif
