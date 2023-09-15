//
// BuilderParameters.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelMachine
  import Foundation
  struct BuilderParameters {
    let manager: any MachineSystem
    let installImage: any InstallerImage
    internal init(manager: any MachineSystem, installImage: any InstallerImage) {
      self.manager = manager
      self.installImage = installImage
    }

    internal init(object: ConfigurationObject, using database: InstallerImageRepository) throws {
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
        let installImage = try database.installImage(
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
      let manager = systemManager.resolve(installImage.metadata.systemID)
      self.init(manager: manager, installImage: installImage)
    }
  }
#endif
