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

  struct SceneConfiguration<
    MachineFileType: FileTypeSpecification,
    LibraryFileType: InitializableFileTypeSpecification
  >: ApplicationConfiguration, Loggable {
    static var loggingCategory: BushelLogging.Category {
      .application
    }

    let systems: [any System]

    let xpcService: String

    let schemas: [any PersistentModel.Type] =
      .all

    var allowedOpenFileTypes: [FileType] {
      [.virtualMachine, .restoreImageLibrary]
    }

    var modelContainer: ModelContainer {
      SharedDatabase.shared.modelContainer
    }

    var database: any Database {
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

    func installerImageRepository(_ database: any Database) -> any InstallerImageRepository {
      DatabaseInstallerRepository(database: database)
    }

    func openFileURL(_ url: URL, openWindow: OpenWindowAction) {
      if let file = MachineFile.documentFile(from: url) {
        openWindow(value: file)
      } else if let file = LibraryFile.documentFile(from: url) {
        openWindow(value: file)
      } else {
        assertionFailure("Unknown document type for: \(url)")
        SceneConfiguration.logger.error("Unknown document type for: \(url)")
      }
    }

    func hubView(_ image: Binding<(any InstallImage)?>) -> some View {
      HubView(selectedHubImage: image)
    }
  }
#endif
