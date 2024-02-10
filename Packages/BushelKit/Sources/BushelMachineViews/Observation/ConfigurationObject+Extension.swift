//
// ConfigurationObject+Extension.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import Observation

  extension ConfigurationObject {
    func verify() {}

    func machineURL(fromBuildResult buildResult: Result<URL, BuilderError>?) -> URL? {
      switch buildResult {
      case let .failure(error):
        self.error = .machineBuilderError(error)
        fallthrough

      case .none:
        return nil

      case let .success(url):
        return url
      }
    }

    func onRestoreImageChange(from _: UUID?, to newRestoreImageID: UUID?) {
      assert(newRestoreImageID == self.configuration.restoreImageID)
      Self.logger.debug("restore image change to \(newRestoreImageID?.uuidString ?? "null")")
      self.beginUpdateMetadataAt(basedOn: newRestoreImageID)
    }

    func onBuildRequestChange(from _: MachineBuildRequest?, to request: MachineBuildRequest?) {
      Self.logger.debug("build request change to \(request?.restoreImage?.description ?? "null")")
      self.configuration.updating(forRequest: request)

      guard let restoreImageID = request?.restoreImage?.imageID else {
        return
      }
      self.beginUpdateMetadataAt(basedOn: restoreImageID)
    }

    func machineConfiguration(
      using database: any InstallerImageRepository
    ) async throws -> MachineConfiguration {
      Self.logger.debug("creating configuration")
      guard let restoreImageID = configuration.restoreImageID else {
        let error = ConfigurationError.missingRestoreImageID
        assertionFailure(error: error)
        Self.logger.error("Missing restoreImageID: \(error.localizedDescription)")
        throw error
      }
      guard
        let labelProvider,
        let image = try await database.image(
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

    func beginBuildRequest(
      for result: Result<URL, any Error>,
      using database: any InstallerImageRepository
    ) {
      do {
        try result.flatMap { url in
          Result {
            try self.beginCreateBuilder(url, using: database)
          }
        }
        .get()
      } catch let error as ConfigurationError {
        self.error = error
        Self.logger.error("Unable to create build, error: \(error)")
      } catch {
        self.error = .unknownError(error)
        Self.logger.critical("Unable to create build unknown error: \(error)")
      }
    }

    func beginCreateBuilder(_ url: URL, using database: any InstallerImageRepository) {
      Task {
        let parameters = try await BuilderParameters(object: self, using: database)
        do {
          Self.logger.error("Creating builder for \(url)")
          let builder = try await parameters.manager.createBuilder(
            for: configuration,
            image: parameters.image,
            at: url.appendingPathComponent(URL.bushel.paths.machineDataDirectoryName)
          )
          self.builder = .init(builder: builder)
        } catch let error as BuilderError {
          Self.logger.error("Unable to create builder: \(error)")
          self.error = .machineBuilderError(error)
          self.lastDestinationURL = url
        } catch {
          Self.logger.critical("Unable to create builder: \(error)")
          self.error = .unknownError(error)
          self.lastDestinationURL = url
        }
      }
    }

    public func getDestinationURL(assertionFailureIfNil: Bool) -> URL? {
      let destinationDataURL = self.builder?.builder.url ?? self.lastDestinationURL
      if assertionFailureIfNil {
        assert(destinationDataURL != nil)
      }
      return destinationDataURL?.deletingLastPathComponent()
    }
  }

#endif
