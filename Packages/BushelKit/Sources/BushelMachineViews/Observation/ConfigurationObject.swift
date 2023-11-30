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
  import SwiftData

  @Observable
  final class ConfigurationObject: Loggable {
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

    var isAlertPresented: Bool = false

    @ObservationIgnored
    internal private(set) var systemManager: MachineSystemManaging?

    @ObservationIgnored
    internal private(set) var labelProvider: MetadataLabelProvider?

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
          self.images = try database
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
    internal private(set) var database: InstallerImageRepository?

    internal init(
      configuration: MachineSetupConfiguration,
      builder: MachineBuilderActivity? = nil,
      error: ConfigurationError? = nil
    ) {
      self._configuration = configuration
      self._builder = builder
      self._error = error
    }

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

    func updateMetadataAt(basedOn restoreImageID: UUID?) {
      guard let restoreImageID else {
        self.restoreImageMetadata = nil
        return
      }
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
        image = try database.image(
          withID: restoreImageID,
          library: self.configuration.libraryID,
          labelProvider
        )
      } catch let error as SwiftDataError {
        assertionFailure(error: error)
        Self.logger.error("Database error fetching image \(restoreImageID): \(error)")
        self.error = .databaseError(error)
        return
      } catch {
        assertionFailure(error: error)

        Self.logger.critical("Unknown error fetching image \(restoreImageID): \(error)")
        self.error = .unknownError(error)
        return
      }

      self.restoreImageMetadata = image?.metadata
    }

    func prepareBuild(using database: InstallerImageRepository) {
      let machineConfiguration: MachineConfiguration
      do {
        machineConfiguration = try self.machineConfiguration(using: database)
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
