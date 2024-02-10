//
// BuilderParameters.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelMachine
  import Foundation
  struct BuilderParameters {
    let manager: any MachineSystem
    let image: any InstallerImage
    internal init(manager: any MachineSystem, image: any InstallerImage) {
      self.manager = manager
      self.image = image
    }

    internal init(object: ConfigurationObject, using database: any InstallerImageRepository) async throws {
      guard let systemManager = object.systemManager else {
        let error = ConfigurationError.missingSystemManager
        assertionFailure(error: error)
        throw error
      }

      guard let restoreImageID = object.configuration.restoreImageID else {
        let error = ConfigurationError.missingRestoreImageID
        assertionFailure(error: error)
        throw error
      }

      guard
        let labelProvider = object.labelProvider,
        let image = try await database.image(
          withID: restoreImageID,
          library: object.configuration.libraryID,
          labelProvider
        ) else {
        let error = ConfigurationError.restoreImageNotFound(
          restoreImageID,
          library: object.configuration.libraryID
        )
        assertionFailure(error: error)
        throw error
      }
      let manager = systemManager.resolve(image.metadata.vmSystemID)
      self.init(manager: manager, image: image)
    }
  }
#endif
