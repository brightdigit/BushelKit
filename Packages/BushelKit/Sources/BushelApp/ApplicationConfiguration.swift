//
// ApplicationConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import BushelDataCore
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

    var modelContainer: ModelContainer { get }

    var database: any Database { get }

    func hubView(_ image: Binding<(any InstallImage)?>) -> HubViewType

    func installerImageRepository(_ database: any Database) -> any InstallerImageRepository

    func openFileURL(_ url: URL, openWindow: OpenWindowAction)
  }

#endif
