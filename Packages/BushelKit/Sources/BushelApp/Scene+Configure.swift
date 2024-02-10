//
// Scene+Configure.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import BushelData
  import BushelLogging
  import BushelMachine
  import BushelOnboardingCore
  import BushelOnboardingViews
  import BushelSystem
  import BushelViewsCore
  import SwiftData
  import SwiftUI
  import TipKit

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    func configure<
      MachineFileType: FileTypeSpecification,
      LibraryFileType: InitializableFileTypeSpecification
    >(
      libraryFileType: LibraryFileType.Type,
      machineFileType: MachineFileType.Type,
      @SystemBuilder _ systems: @escaping () -> [any System]
    ) -> some View {
      self.configure(SceneConfiguration<MachineFileType, LibraryFileType>(systems))
    }

    func configure(
      _ configuration: some ApplicationConfiguration
    ) -> some View {
      #if os(macOS)
        self
          .modelContainer(configuration.modelContainer)
          .hubView(configuration.hubView(_:))
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .newLibrary(type(of: configuration).LibraryFileType)
          .openMachine(type(of: configuration).MachineFileType)
          .allowedOpenFileTypes(configuration.allowedOpenFileTypes)
          .registerSystems(configuration.systems)
      #else
        self
          .modelContainer(configuration.modelContainer)
          .hubView(configuration.hubView(_:))
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .registerSystems(configuration.systems)
      #endif
    }
  }

  #if os(macOS)
    public extension Scene {
      func onboardingWindow<SingleWindowViewType: SingleWindowView>(
        _ view: SingleWindowViewType.Type
      ) -> some Scene where SingleWindowViewType.Value == OnboardingWindowValue {
        self.environment(\.onboardingWindow, view.Value.default)
      }
    }
  #endif

  extension Scene {
    func configure<
      MachineFileType: FileTypeSpecification,
      LibraryFileType: InitializableFileTypeSpecification
    >(
      libraryFileType: LibraryFileType.Type,
      machineFileType: MachineFileType.Type,
      @SystemBuilder _ systems: @escaping () -> [any System]
    ) -> some Scene {
      self.configure(SceneConfiguration<MachineFileType, LibraryFileType>(systems))
    }

    func configure(
      _ configuration: some ApplicationConfiguration
    ) -> some Scene {
      let logger = BushelLogging.logger(forCategory: .application)
      if EnvironmentConfiguration.shared.resetApplication {
        logger.debug("Clearing application data")
        do {
          try Bundle.main.clearUserDefaults()
          try FileManager.default.clearSavedApplicationState()
          #warning("Add thing for clearing database")
          logger.debug("Clearing completed")
        } catch {
          logger.error("Unable to reset application: \(error)")
          assertionFailure(error: error)
        }
      }
      #if os(macOS)
        return self
          .modelContainer(configuration.modelContainer)
          .database(configuration.modelContainer)
          .onboardingWindow(OnboardingView.self)
          .hubView(configuration.hubView(_:))
          .installerImageRepository(configuration.installerImageRepository)
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .newLibrary(type(of: configuration).LibraryFileType)
          .openLibrary(type(of: configuration).LibraryFileType)
          .openMachine(type(of: configuration).MachineFileType)
          .allowedOpenFileTypes(configuration.allowedOpenFileTypes)
          .snapshotProvider([FileVersionSnapshotterFactory()])
          .registerSystems(configuration.systems)
      #else
        return self.modelContainer(configuration.modelContainer)
          .hubView(configuration.hubView(_:))
          .installerImageRepository(configuration.installerImageRepository)
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .registerSystems(configuration.systems)
      #endif
    }
  }
#endif
