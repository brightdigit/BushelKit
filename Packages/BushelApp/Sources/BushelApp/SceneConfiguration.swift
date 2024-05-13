//
// SceneConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import BushelData
  import BushelFactoryRepository
  import BushelHubViews
  import BushelLibrary
  import BushelLogging
  import BushelMachine
  import BushelSystem
  import SwiftData
  import SwiftUI

  internal struct SceneConfiguration<
    MachineFileType: FileTypeSpecification,
    LibraryFileType: InitializableFileTypeSpecification
  >: ApplicationConfiguration, Loggable {
    internal static var loggingCategory: BushelLogging.Category {
      .application
    }

    internal let systems: [any System]

    internal let xpcService: String

    internal let schemas: [any PersistentModel.Type] =
      .all

    internal var allowedOpenFileTypes: [FileType] {
      [.virtualMachine, .restoreImageLibrary]
    }

    internal var modelContainer: ModelContainer {
      SharedDatabase.shared.modelContainer
    }

    internal var database: any Database {
      SharedDatabase.shared.database
    }

    internal init(
      // swiftlint:disable:next force_unwrapping
      xpcService: String = Bundle.main.xpcService!,
      @SystemBuilder _ systems: @escaping () -> [any System]
    ) {
      self.xpcService = xpcService

      self.systems = systems()
    }

    internal func installerImageRepository(_ database: any Database) -> any InstallerImageRepository {
      DatabaseInstallerRepository(database: database)
    }

    internal func openFileURL(_ url: URL, openWindow: OpenWindowAction) {
      if let file = MachineFile.documentFile(from: url) {
        openWindow(value: file)
      } else if let file = LibraryFile.documentFile(from: url) {
        openWindow(value: file)
      } else {
        assertionFailure("Unknown document type for: \(url)")
        SceneConfiguration.logger.error("Unknown document type for: \(url)")
      }
    }

    internal func hubView(_ image: Binding<(any InstallImage)?>) -> some View {
      HubView(selectedHubImage: image)
    }
  }
#endif
