//
// ApplicationConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import BushelMachine
  import BushelSystem
  import SwiftData
  import SwiftUI

  protocol ApplicationConfiguration {
    associatedtype LibraryFileType: InitializableFileTypeSpecification
    associatedtype MachineFileType: FileTypeSpecification
    associatedtype HubViewType: View

    var systems: [System] { get }

    var schemas: [any PersistentModel.Type] { get }

    func hubView(_ image: Binding<InstallImage?>) -> HubViewType

    func installerImageRepository(_ context: ModelContext) -> InstallerImageRepository

    func openFileURL(_ url: URL, openWindow: OpenWindowAction)
  }

  extension ApplicationConfiguration {
    var modelContainer: ModelContainer {
      .forTypes(schemas)
    }
  }
#endif
