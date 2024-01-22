//
// InstallerImageRepository+ConfigurationObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData

  extension InstallerImageRepository {
    func imageBasedOn(
      _ restoreImageID: UUID,
      libraryID: LibraryIdentifier?,
      logger: Logger,
      _ labelProvider: MetadataLabelProvider?
    ) throws -> (any InstallerImage)? {
      guard let labelProvider else {
        assertionFailure("Missing label Provider")
        return nil
      }
      let image: (any InstallerImage)?
      do {
        image = try self.image(
          withID: restoreImageID,
          library: libraryID,
          labelProvider
        )
      } catch let error as SwiftDataError {
        assertionFailure(error: error)
        logger.error("Database error fetching image \(restoreImageID): \(error)")
        throw ConfigurationError.databaseError(error)
      } catch {
        assertionFailure(error: error)

        logger.critical("Unknown error fetching image \(restoreImageID): \(error)")
        throw ConfigurationError.unknownError(error)
      }
      return image
    }
  }

  extension Optional where Wrapped == any InstallerImageRepository {
    func imageBasedOn(
      _ restoreImageID: UUID,
      libraryID: LibraryIdentifier?,
      logger: Logger,
      _ labelProvider: MetadataLabelProvider?
    ) throws -> (any InstallerImage)? {
      guard let database = self else {
        assertionFailure("Missing database.")
        return nil
      }

      return try database.imageBasedOn(
        restoreImageID,
        libraryID: libraryID,
        logger: logger,
        labelProvider
      )
    }
  }
#endif
