//
// ModelContext.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelMachine
  import Foundation
  import SwiftData

  extension ModelContext: InstallerImageRepository {
    public func installImage(
      withID id: UUID,
      library: LibraryIdentifier?,
      _ labelProvider: @escaping (VMSystemID, ImageMetadata) -> MetadataLabel
    ) throws -> InstallerImage? {
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
        guard let image = library.images?.first(where: { $0.imageID == id }) else {
          return nil
        }
        return DataInstallerImage(entry: image, context: self, labelProvider)

      case .none:
        var imagePredicate = FetchDescriptor<LibraryImageEntry>(
          predicate: #Predicate { $0.imageID == id }
        )
        imagePredicate.fetchLimit = 1
        guard let image = try self.fetch(imagePredicate).first else {
          return nil
        }
        return DataInstallerImage(entry: image, context: self, labelProvider)

      case let .url(url):
        return try URLInstallerImage(imageID: id, url: url, labelProvider)
      }
    }
  }
#endif
