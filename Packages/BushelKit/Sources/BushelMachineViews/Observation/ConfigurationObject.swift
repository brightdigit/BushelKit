//
// ConfigurationObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import Observation

  @Observable
  final class ConfigurationObject: LoggerCategorized {
    struct Image: Identifiable {
      let installerImage: any InstallerImage

      var id: UUID {
        installerImage.imageID
      }

      var libraryID: LibraryIdentifier? {
        installerImage.libraryID
      }

      var metadata: InstallerImageMetadata {
        installerImage.metadata
      }
    }

    enum ConfigurationError: Error {
      case missingRestoreImageID
      case missingSystemManager
      case restoreImageNotFound(UUID, library: LibraryIdentifier?)
    }

    var sheetSelectedRestoreImageID: UUID? {
      didSet {
        self.configuration.restoreImageID = sheetSelectedRestoreImageID
        guard let sheetSelectedRestoreImageID else {
          return
        }
        self.configuration.libraryID = nil
        self.updateMetadataAt(basedOn: sheetSelectedRestoreImageID)
      }
    }

    var configuration: MachineSetupConfiguration
    var restoreImageMetadata: InstallerImage.Metadata?
    var builder: MachineBuilderActivity?
    var machineConfiguration: MachineConfiguration?
    var error: Error?

    @ObservationIgnored
    var systemManager: MachineSystemManaging?

    @ObservationIgnored
    var labelProvider: MetadataLabelProvider?

    var presentFileExporter: Bool = false
    var presentImageSelection: Bool = false {
      didSet {
        guard let labelProvider else {
          assertionFailure("Missing label Provider")
          return
        }
        guard let database else {
          assertionFailure("Missing database Provider")
          return
        }
        do {
          self.images = try database.installImages(labelProvider).map(Image.init(installerImage:))
        } catch {
          assertionFailure(error: error)
          self.error = error
        }
      }
    }

    var images: [Image]?

    var isBuildable: Bool {
      self.configuration.restoreImageID != nil
    }

    var defaultFileName: String {
      if let restoreImageMetadata {
        restoreImageMetadata.labelName
      } else {
        "Machine"
      }
    }

    @ObservationIgnored
    var database: InstallerImageRepository?

    internal init(
      configuration: MachineSetupConfiguration,
      builder: MachineBuilderActivity? = nil,
      error: Error? = nil
    ) {
      self._configuration = configuration
      self._builder = builder
      self._error = error
    }

    func verify() {}

    func setupFrom(
      request: MachineBuildRequest?,
      systemManager: MachineSystemManaging,
      using database: InstallerImageRepository,
      labelProvider: @escaping (MetadataLabelProvider)
    ) {
      self.configuration.updating(forRequest: request)
      self.database = database
      self.systemManager = systemManager
      self.labelProvider = labelProvider

      guard let restoreImageID = request?.restoreImage?.imageID else {
        return
      }
      self.updateMetadataAt(basedOn: restoreImageID)
    }

    private func updateMetadataAt(basedOn restoreImageID: UUID) {
      guard let labelProvider else {
        assertionFailure("Missing label Provider")
        return
      }

      guard let database else {
        assertionFailure("Missing database.")
        return
      }
      let image: (any InstallerImage)?
      do {
        image = try database.installImage(
          withID: restoreImageID,
          library: self.configuration.libraryID,
          labelProvider
        )
      } catch {
        self.error = error
        return
      }

      self.restoreImageMetadata = image?.metadata
    }

    func onRestoreImageChange(from _: UUID?, to newRestoreImageID: UUID?) {
      assert(newRestoreImageID == self.configuration.restoreImageID)
      guard let restoreImageID = self.configuration.restoreImageID else {
        self.restoreImageMetadata = nil
        return
      }

      self.updateMetadataAt(basedOn: restoreImageID)
    }

    func onBuildRequestChange(from _: MachineBuildRequest?, to request: MachineBuildRequest?) {
      self.configuration.updating(forRequest: request)

      guard let restoreImageID = request?.restoreImage?.imageID else {
        return
      }
      self.updateMetadataAt(basedOn: restoreImageID)
    }

    func prepareBuild(using database: InstallerImageRepository) {
      let machineConfiguration: MachineConfiguration
      do {
        machineConfiguration = try self.machineConfiguration(using: database)
      } catch {
        self.error = error
        return
      }
      self.machineConfiguration = machineConfiguration
      self.presentFileExporter = true
    }

    func machineConfiguration(using database: InstallerImageRepository) throws -> MachineConfiguration {
      guard let restoreImageID = configuration.restoreImageID else {
        let error = ConfigurationError.missingRestoreImageID
        assertionFailure(error: error)
        throw error
      }
      guard
        let labelProvider,
        let installImage = try database.installImage(
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
      return .init(setup: configuration, restoreImageFile: installImage)
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
      guard let systemManager else {
        let error = ConfigurationError.missingSystemManager
        assertionFailure(error: error)
        throw error
      }
      guard let restoreImageID = configuration.restoreImageID else {
        let error = ConfigurationError.missingRestoreImageID
        assertionFailure(error: error)
        throw error
      }

      guard
        let labelProvider,
        let installImage = try database.installImage(
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
      let manager = systemManager.resolve(installImage.metadata.systemID)
      Task {
        do {
          let builder = try await manager.createBuilder(
            for: configuration,
            image: installImage,
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
