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
      Self.logger.debug("restore image change to \(newRestoreImageID?.uuidString ?? "null")")
      self.updateMetadataAt(basedOn: newRestoreImageID)
    }

    func onBuildRequestChange(from _: MachineBuildRequest?, to request: MachineBuildRequest?) {
      Self.logger.debug("build request change to \(request?.restoreImage?.description ?? "null")")
      self.configuration.updating(forRequest: request)

      guard let restoreImageID = request?.restoreImage?.imageID else {
        return
      }
      self.updateMetadataAt(basedOn: restoreImageID)
    }

    func machineConfiguration(using database: InstallerImageRepository) throws -> MachineConfiguration {
      Self.logger.debug("creating configuration")
      guard let restoreImageID = configuration.restoreImageID else {
        let error = ConfigurationError.missingRestoreImageID
        assertionFailure(error: error)
        Self.logger.error("Missing restoreImageID: \(error.localizedDescription)")
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
        Self.logger.error("restoreImage \(restoreImageID) NotFound: \(error.localizedDescription)")
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
          Self.logger.error("Creating builder for \(url)")
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
