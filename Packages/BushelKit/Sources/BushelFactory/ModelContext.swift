//
// ModelContext.swift
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

  extension ModelContext: InstallerImageRepository {
    public func removeImage(_ images: any InstallerImage) throws -> RemoveImageFailure? {
      guard case let .bookmarkID(bookmarkDataID) = images.libraryID else {
        return .notSupported
      }

      let imageID = images.imageID
      var libraryPredicate = FetchDescriptor<LibraryImageEntry>(
        predicate: #Predicate { $0.imageID == imageID && $0.library?.bookmarkDataID == bookmarkDataID }
      )
      libraryPredicate.fetchLimit = 1
      guard let imageEntry = try self.fetch(libraryPredicate).first else {
        return .notFound
      }

      try self.delete(imageEntry)
      return nil
    }

    public func images(
      _ labelProvider: @escaping MetadataLabelProvider) throws -> [any InstallerImage] {
      try self.delete(model: LibraryImageEntry.self, where: #Predicate { $0.library == nil })
      let imagePredicate = FetchDescriptor<LibraryImageEntry>()
      let images = try self.fetch(imagePredicate)
      return images.map { entry in
        DataInstallerImage(entry: entry, context: self, labelProvider)
      }
    }

    #warning("logging-note: what about all else of guard statements here, and the switch cases too")
    // swiftlint:disable:next cyclomatic_complexity
    public func image(
      withID id: UUID,
      library: LibraryIdentifier?,
      _ labelProvider: @escaping MetadataLabelProvider
    ) throws -> (any InstallerImage)? {
      switch library {
      case let .bookmarkID(bookmarkDataID):
        var libraryPredicate = FetchDescriptor<LibraryEntry>(
          predicate: #Predicate { $0.bookmarkDataID == bookmarkDataID }
        )

        libraryPredicate.fetchLimit = 1
        let items = try self.fetch(libraryPredicate)
        guard let library = items.first else {
          return nil
        }
        guard let images = library.images?.first(where: { $0.imageID == id }) else {
          return nil
        }
        return DataInstallerImage(entry: images, context: self, labelProvider)

      case .none:
        var imagePredicate = FetchDescriptor<LibraryImageEntry>(
          predicate: #Predicate { $0.imageID == id }
        )
        imagePredicate.fetchLimit = 1
        guard let images = try self.fetch(imagePredicate).first else {
          return nil
        }
        guard images.library != nil else {
          return nil
        }
        return DataInstallerImage(entry: images, context: self, labelProvider)

      case let .url(url):
        return try URLInstallerImage(imageID: id, url: url, labelProvider)
      }
    }
  }

#endif
