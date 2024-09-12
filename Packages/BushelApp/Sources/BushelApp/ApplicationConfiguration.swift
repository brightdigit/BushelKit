//
// ApplicationConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import BushelMachine
  import BushelSystem
  import DataThespian
  import RadiantDocs
  import RadiantKit
  import SwiftData
  import SwiftUI

  internal protocol ApplicationConfiguration: Sendable {
    associatedtype LibraryFileType: InitializableFileTypeSpecification
    associatedtype MachineFileType: FileTypeSpecification
    associatedtype HubViewType: View

    var systems: [any System] { get }

    var allowedOpenFileTypes: [FileType] { get }

    var modelContainer: ModelContainer { get }

    var database: any Database { get }

    var xpcService: String { get }

    @MainActor
    func hubView(_ image: Binding<(any InstallImage)?>) -> HubViewType

    @Sendable
    func installerImageRepository(_ database: any Database) -> any InstallerImageRepository

    @MainActor
    func openFileURL(_ url: URL, openWindow: OpenWindowAction)
  }

#endif
