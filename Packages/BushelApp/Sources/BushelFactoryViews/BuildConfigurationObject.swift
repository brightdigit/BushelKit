//
// BuildConfigurationObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelFactory
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import SwiftData
  import SwiftUI

  @Observable
  internal final class BuildConfigurationObject: Loggable, Sendable, MachineConfigurable {
    internal static let loggingCategory: BushelLogging.Category = .observation

    internal let system: VMSystemID

    internal var presentFileExporter = false

    @ObservationIgnored
    private var labelProvider: MetadataLabelProvider?

    @ObservationIgnored
    private var imageRepository: (any InstallerImageRepository)?

    @ObservationIgnored
    internal var machineSystem: (any MachineSystem)?

    internal var error: ConfigurationError? {
      didSet {
        self.isAlertPresented = self.error != nil
      }
    }

    internal var isAlertPresented = false

    internal var promptForLibrary = false

    internal var activeBuild: MachineBuilderActivity? {
      willSet {
        self.lastDestinationURL = self.activeBuild?.id ?? self.lastDestinationURL
      }
    }

    private var defaultBaseName: String {
      if let restoreImageMetadata = self.selectedBuildImage.image?.metadata {
        restoreImageMetadata.labelName
      } else {
        "Machine"
      }
    }

    internal var defaultFileName: String {
      [self.defaultBaseName, FileType.virtualMachineFileExtension].joined(separator: ".")
    }

    internal private(set) var machineConfiguration: MachineConfiguration?

    internal private(set) var lastDestinationURL: URL?

    internal var releaseSelection: ReleaseSelected = .none {
      didSet {
        let newAvailableVersions: [any InstallerImage]? = switch releaseSelection {
        case let .version(release):
          self.releases?[release.metadata.majorVersion]?.images

        case .custom:
          self.releases?.customVersions

        case .none:
          []
        }
        assert(newAvailableVersions != nil)
        let newSelectedVersions = newAvailableVersions?.map(SelectedVersion.init(image:)) ?? []
        self.availableVersions = newSelectedVersions
        self.selectedBuildImage = newSelectedVersions.last ?? .none
      }
    }

    internal private(set) var availableVersions: [SelectedVersion] = []

    internal var selectedBuildImage: SelectedVersion = .none {
      didSet {
        assert(self.machineSystem != nil)
        self.specificationConfiguration = self.selectedBuildImage.image
          .flatMap {
            self.machineSystem?.configurationRange(for: $0)
          }
          .map {
            SpecificationConfiguration(range: $0)
          }
      }
    }

    @ObservationIgnored
    internal var buildRequest: MachineBuildRequest?

    internal private(set) var releases: ReleaseCollection? {
      didSet {
        self.promptForLibrary = releases?.isEmpty ?? false
      }
    }

    internal var specificationConfiguration: SpecificationConfiguration<LocalizedStringID>?

    internal var releasePrefix: String? {
      releases?.prefix
    }

    internal init(
      system: VMSystemID
    ) {
      self.system = system
    }

    internal func updateSelection(basedOn request: MachineBuildRequest) {
      assert(releases != nil)
      guard let releases else {
        return
      }
      guard let imageID = request.restoreImage else {
        self.releaseSelection = .none
        self.selectedBuildImage = .none
        return
      }

      guard let selection = releases.findSelection(byID: imageID) else {
        let error: ConfigurationError = .restoreImageNotFound(imageID.imageID, library: imageID.libraryID)
        assertionFailure(error: error)
        self.error = error
        return
      }

      self.releaseSelection = selection.release
      self.selectedBuildImage = selection.version
    }

    internal func setup(
      releaseCollectionProvider: @escaping ReleaseCollectionMetadataProvider,
      imageRepository: any InstallerImageRepository,
      metadataLabelProvider: @escaping MetadataLabelProvider
    ) async throws {
      self.releases = try await ReleaseCollection(
        releaseCollection: releaseCollectionProvider(self.system),
        images: imageRepository.images(metadataLabelProvider)
      )
      self.labelProvider = metadataLabelProvider
      self.imageRepository = imageRepository
      if let buildRequest {
        self.updateSelection(basedOn: buildRequest)
      }
    }

    @discardableResult
    internal func prepareBuild() -> Bool {
      let machineConfiguration: MachineConfiguration
      do {
        machineConfiguration = try MachineConfiguration(configurable: self)
      } catch let error as ConfigurationError {
        Self.logger.error("Error preparing build: \(self.withError(error))")
        return false
      } catch {
        Self.logger.critical("Error preparing build: \(self.withError(.unknownError(error)))")

        return false
      }
      self.machineConfiguration = machineConfiguration
      return true
    }

    internal func beginBuild(at url: URL) {
      guard let machineSystem else {
        assertionFailure("Machine System Not Set.")
        return
      }
      guard let machineConfiguration, let image = selectedBuildImage.image else {
        assertionFailure("No Selected Image.")
        return
      }

      defer {
        self.lastDestinationURL = url
      }
      Task {
        let builder: any MachineBuilder
        do {
          builder = try await machineSystem.createBuilder(
            for: machineConfiguration,
            image: image,
            withDataDirectoryAt: url.appendingPathComponent(URL.bushel.paths.machineDataDirectoryName)
          )
        } catch let error as BuilderError {
          Self.logger.error("Unable to begin build: \(self.withError(.machineBuilderError(error)))")
          return
        } catch {
          Self.logger.critical("Unable to create build: \(self.withError(error)))")
          return
        }

        await MainActor.run {
          self.activeBuild = .init(builder: builder)
        }
      }
    }
  }
#endif
