//
// ConfigurationObject+Extension.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import Observation

  extension ConfigurationObject {
    func verify() {}

    func onRestoreImageChange(from _: UUID?, to newRestoreImageID: UUID?) {
      assert(newRestoreImageID == self.configuration.restoreImageID)
      self.updateMetadataAt(basedOn: newRestoreImageID)
    }

    func onBuildRequestChange(from _: MachineBuildRequest?, to request: MachineBuildRequest?) {
      self.configuration.updating(forRequest: request)

      guard let restoreImageID = request?.restoreImage?.imageID else {
        return
      }
      self.updateMetadataAt(basedOn: restoreImageID)
    }

    func machineConfiguration(using database: InstallerImageRepository) throws -> MachineConfiguration {
      guard let restoreImageID = configuration.restoreImageID else {
        let error = ConfigurationError.missingRestoreImageID
        assertionFailure(error: error)
        throw error
      }
      guard
        let labelProvider,
        let image = try database.image(
          withID: restoreImageID,
          library: configuration.libraryID,
          labelProvider
        ) else {
        let error = ConfigurationError.restoreImageNotFound(
          restoreImageID,
          library: configuration.libraryID
        )
        assertionFailure(error: error)
        throw error
      }
      return .init(setup: configuration, restoreImageFile: image)
    }

    func beginBuildRequest(for result: Result<URL, Error>, using database: InstallerImageRepository) {
      do {
        try result.flatMap { url in
          Result {
            try self.beginCreateBuilder(url, using: database)
          }
        }
        .get()
      } catch {
        self.error = error
      }
    }

    func beginCreateBuilder(_ url: URL, using database: InstallerImageRepository) throws {
      let parameters = try BuilderParameters(object: self, using: database)
      Task {
        do {
          let builder = try await parameters.manager.createBuilder(
            for: configuration,
            image: parameters.image,
            at: url.appendingPathComponent(Paths.machineDataDirectoryName)
          )
          self.builder = .init(builder: builder)
        } catch {
          Self.logger.error("Unable to create builder: \(error)")
          self.error = error
        }
      }
    }
  }

#endif
