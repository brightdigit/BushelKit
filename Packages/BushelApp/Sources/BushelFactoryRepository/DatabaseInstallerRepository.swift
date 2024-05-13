//
// DatabaseInstallerRepository.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelData
  import BushelFactory
  import BushelMachine
  import Foundation
  import SwiftData

  public struct DatabaseInstallerRepository: InstallerImageRepository {
    private let database: any Database

    public init(database: any Database) {
      self.database = database
    }

    public func images(
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> [any BushelMachine.InstallerImage] {
      try await database.delete(model: LibraryImageEntry.self, where: #Predicate { $0.library == nil })
      let imagePredicate = FetchDescriptor<LibraryImageEntry>()
      let images = try await database.fetch(imagePredicate)
      return images.map { entry in
        DataInstallerImage(entry: entry, database: database, labelProvider)
      }
    }

    public func image(
      withID id: UUID,
      library: BushelCore.LibraryIdentifier?,
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> (any BushelMachine.InstallerImage)? {
      switch library {
      case let .bookmarkID(bookmarkDataID):
        try await DataInstallerImage(
          id: id,
          bookmarkDataID: bookmarkDataID,
          database: database,
          labelProvider
        )

      case .none:
        try await DataInstallerImage(
          id: id,
          database: database,
          labelProvider
        )

      case let .url(url):
        try URLInstallerImage(imageID: id, url: url, labelProvider)
      }
    }

    public func removeImage(
      _ image: any BushelMachine.InstallerImage)
      async throws -> BushelMachine.RemoveImageFailure? {
      guard case let .bookmarkID(bookmarkDataID) = image.libraryID else {
        return .notSupported
      }

      let imageID = image.imageID
      var libraryPredicate = FetchDescriptor<LibraryImageEntry>(
        predicate: #Predicate { $0.imageID == imageID && $0.library?.bookmarkDataID == bookmarkDataID }
      )
      libraryPredicate.fetchLimit = 1
      guard let imageEntry = try await database.fetch(libraryPredicate).first else {
        return .notFound
      }

      await database.delete(imageEntry)
      return nil
    }
  }
#endif
