//
// DatabaseInstallerRepository.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  public import BushelCore

  import BushelData
  import BushelFactory

  public import BushelMachine

  public import Foundation
  import SwiftData

  public import DataThespian

  public struct DatabaseInstallerRepository: InstallerImageRepository {
    private let database: any Database

    public init(database: any Database) {
      self.database = database
    }

    public func images(
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> [any BushelMachine.InstallerImage] {
      try await database.delete(model: LibraryImageEntry.self, where: #Predicate { $0.library == nil })

      return try await database.fetch(LibraryImageEntry.self) { images in
        images.map { entry in
          DataInstallerImage(entry: entry, database: database, labelProvider)
        }
      }
    }

    public func image(
      withID id: UUID,
      library: BushelCore.LibraryIdentifier?,
      _ labelProvider: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> (any BushelMachine.InstallerImage)? {
      switch library {
      case let .bookmarkID(bookmarkDataID):
        try await DataInstallerImage.fromDatabase(database, withImageID: id, bookmarkDataID: bookmarkDataID, labelProvider)

      case .none:
        try await DataInstallerImage.fromDatabase(database, withImageID: id, labelProvider)

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

      let imageModel: ModelID? = try await database.first(#Predicate<LibraryImageEntry> { $0.imageID == imageID && $0.library?.bookmarkDataID == bookmarkDataID })

      guard let imageModel else {
        return .notFound
      }

      await database.delete(imageModel)
      return nil
    }
  }
#endif
