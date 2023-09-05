//
// Scene+Configure.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import BushelSystem
  import SwiftUI

  extension Scene {
    func configure<
      MachineFileType: FileTypeSpecification,
      LibraryFileType: InitializableFileTypeSpecification
    >(
      libraryFileType: LibraryFileType.Type,
      machineFileType: MachineFileType.Type,
      @SystemBuilder _ systems: @escaping () -> [System]
    ) -> some Scene {
      self.configure(SceneConfiguration<MachineFileType, LibraryFileType>(systems))
    }

    func configure(
      _ configuration: some ApplicationConfiguration
    ) -> some Scene {
      self.modelContainer(configuration.modelContainer)
        .hubView(configuration.hubView(_:))
        .installerImageRepository(configuration.installerImageRepository)
        .openFileURL(configuration.openFileURL(_:openWindow:))
        .newLibrary(type(of: configuration).LibraryFileType)
        .openMachine(type(of: configuration).MachineFileType)
        .registerSystems(configuration.systems)
    }
  }
#endif
