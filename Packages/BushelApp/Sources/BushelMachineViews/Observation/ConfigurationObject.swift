//
// ConfigurationObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelFactory
  import BushelLogging
  import BushelMachine
  import Foundation
  import Observation
  import SwiftData

  @Observable
  final class ConfigurationObject: Loggable, Sendable {
    var sheetSelectedRestoreImageID: UUID? {
      didSet {
        self.configuration.restoreImageID = sheetSelectedRestoreImageID
        guard let sheetSelectedRestoreImageID else {
          return
        }
        self.configuration.libraryID = nil
        self.beginUpdateMetadataAt(basedOn: sheetSelectedRestoreImageID)
      }
    }

    var range: ConfigurationRange = .default
    var configuration: MachineSetupConfiguration
    internal private(set) var restoreImageMetadata: InstallerImage.Metadata?
    var builder: MachineBuilderActivity? {
      willSet {
        self.lastDestinationURL = self.builder?.id ?? self.lastDestinationURL
      }
    }

    var lastDestinationURL: URL?
    internal private(set) var machineConfiguration: MachineConfiguration?
    var error: ConfigurationError? {
      didSet {
        self.isAlertPresented = self.error != nil
      }
    }

    var isAlertPresented = false

    @ObservationIgnored
    internal private(set) var systemManager: (any MachineSystemManaging)?

    @ObservationIgnored
    internal private(set) var labelProvider: MetadataLabelProvider?

    var presentFileExporter = false

    var presentImageSelection = false {
      didSet {
        guard let labelProvider else {
          assertionFailure("Missing label Provider")
          return
        }
        guard let database else {
          assertionFailure("Missing database Provider")
          return
        }
        Task {
          do {
            self.images = try await database
              .images(labelProvider)
              .map(ConfigurationImage.init(installerImage:))
          } catch let error as ConfigurationError {
            Self.logger.error("Error fetching image: \(error)")
            assertionFailure(error: error)
            self.error = error
          } catch {
            Self.logger.critical("Unknown error fetching image: \(error)")
            assertionFailure(error: error)
            self.error = .unknownError(error)
          }
        }
      }
    }

    internal private(set) var images: [ConfigurationImage]?

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
    internal private(set) var database: (any InstallerImageRepository)?

    internal init(
      configuration: MachineSetupConfiguration,
      builder: MachineBuilderActivity? = nil,
      error: ConfigurationError? = nil
    ) {
      self._configuration = configuration
      self._builder = builder
      self._error = error
    }

    func beginSetupFrom(
      request: MachineBuildRequest?,
      systemManager: any MachineSystemManaging,
      using database: any InstallerImageRepository,
      labelProvider: @escaping (MetadataLabelProvider)
    ) {
      Task {
        await self.setupFrom(
          request: request,
          systemManager: systemManager,
          using: database,
          labelProvider: labelProvider
        )
      }
    }

    func setupFrom(
      request: MachineBuildRequest?,
      systemManager: any MachineSystemManaging,
      using database: any InstallerImageRepository,
      labelProvider: @escaping (MetadataLabelProvider)
    ) async {
      self.configuration.updating(forRequest: request)
      self.database = database
      self.systemManager = systemManager
      self.labelProvider = labelProvider

      guard let restoreImageID = request?.restoreImage?.imageID else {
        return
      }
      await self.updateMetadataAt(basedOn: restoreImageID)
    }

    func beginUpdateMetadataAt(basedOn restoreImageID: UUID?) {
      Task {
        await self.updateMetadataAt(basedOn: restoreImageID)
      }
    }

    func updateMetadataAt(basedOn restoreImageID: UUID?) async {
      guard let restoreImageID else {
        self.restoreImageMetadata = nil
        return
      }

      guard let systemManager else {
        assertionFailure("Missing system.")
        return
      }

      let image: (any InstallerImage)?
      do {
        image = try await self.database.imageBasedOn(
          restoreImageID,
          libraryID: self.configuration.libraryID,
          logger: Self.logger,
          self.labelProvider
        )
      } catch let error as ConfigurationError {
        self.error = error
        return
      } catch {
        // should never happen
        Self.logger.critical("Unknown error fetching image  \(error)")
        assertionFailure("Unknown error fetching image  \(error)")
        return
      }

      guard let image else {
        assertionFailure("No image found for \(restoreImageID)")
        Self.logger.error("No image found for \(restoreImageID)")
        return
      }

      self.range = image.getConfigurationRange(from: systemManager)
      Self.logger.debug("New Configuration Range: \(self.range)")
      self.restoreImageMetadata = image.metadata
    }

    func beginPrepareBuild(using database: any InstallerImageRepository) {
      Task {
        await self.prepareBuild(using: database)
      }
    }

    func prepareBuild(using database: any InstallerImageRepository) async {
      let machineConfiguration: MachineConfiguration
      do {
        machineConfiguration = try await self.machineConfiguration(using: database)
      } catch let error as ConfigurationError {
        Self.logger.error("Error preparing build: \(error)")
        assertionFailure(error: error)
        self.error = error
        return
      } catch {
        Self.logger.critical("Error preparing build: \(error)")
        assertionFailure(error: error)
        self.error = .unknownError(error)
        return
      }
      self.machineConfiguration = machineConfiguration
      self.presentFileExporter = true
    }
  }

#endif
