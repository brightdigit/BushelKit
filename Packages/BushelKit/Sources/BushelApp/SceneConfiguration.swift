//
// SceneConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
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

    let systems: [BushelSystem.System]

    var schemas: [any PersistentModel.Type] {
      .all
    }

    var allowedOpenFileTypes: [FileType] {
      [.virtualMachine, .restoreImageLibrary]
    }

    internal init(@SystemBuilder _ systems: @escaping () -> [System]) {
      self.systems = systems()
    }

    func installerImageRepository(_ context: ModelContext) -> BushelMachine.InstallerImageRepository {
      context
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

    func hubView(_ image: Binding<InstallImage?>) -> some View {
      HubView(selectedHubImage: image)
    }
  }
#endif
