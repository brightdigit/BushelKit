//
// ApplicationConfiguration.swift
// Copyright (c) 2024 BrightDigit.
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

    var systems: [any System] { get }

    var allowedOpenFileTypes: [FileType] { get }

    var schemas: [any PersistentModel.Type] { get }

    func hubView(_ image: Binding<(any InstallImage)?>) -> HubViewType

    func installerImageRepository(_ context: ModelContext) -> any InstallerImageRepository

    func openFileURL(_ url: URL, openWindow: OpenWindowAction)
  }

  extension ApplicationConfiguration {
    var modelContainer: ModelContainer {
      .forTypes(schemas)
    }
  }
#endif
