//
// Scene+Configure.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
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
      @SystemBuilder _ systems: @escaping () -> [System]
    ) -> some View {
      self.configure(SceneConfiguration<MachineFileType, LibraryFileType>(systems))
    }

    func configure(
      _ configuration: some ApplicationConfiguration
    ) -> some View {
      #if os(macOS)
        self.modelContainer(configuration.modelContainer)
          .hubView(configuration.hubView(_:))
          .installerImageRepository(configuration.installerImageRepository)
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .newLibrary(type(of: configuration).LibraryFileType)
          .openMachine(type(of: configuration).MachineFileType)
          .allowedOpenFileTypes(configuration.allowedOpenFileTypes)
          .registerSystems(configuration.systems)
      #else
        self.modelContainer(configuration.modelContainer)
          .hubView(configuration.hubView(_:))
          .installerImageRepository(configuration.installerImageRepository)
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
      @SystemBuilder _ systems: @escaping () -> [System]
    ) -> some Scene {
      self.configure(SceneConfiguration<MachineFileType, LibraryFileType>(systems))
    }

    func configure(
      _ configuration: some ApplicationConfiguration
    ) -> some Scene {
      if EnvironmentConfiguration.shared.resetApplication {
        Loggers.loggers[.application]?.debug("Clearing application data")
        do {
          try Bundle.main.clearUserDefaults()
          try FileManager.default.clearSavedApplicationState()
          try ModelContext(configuration.modelContainer).clearDatabase()
          Loggers.loggers[.application]?.debug("Clearing completed")
        } catch {
          Loggers.loggers[.application]?.error("Unable to reset application: \(error)")
          assertionFailure(error: error)
        }
      }
      #if os(macOS)
        return self.modelContainer(configuration.modelContainer)
          .onboardingWindow(OnboardingView.self)
          .hubView(configuration.hubView(_:))
          .installerImageRepository(configuration.installerImageRepository)
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .newLibrary(type(of: configuration).LibraryFileType)
          .openMachine(type(of: configuration).MachineFileType)
          .allowedOpenFileTypes(configuration.allowedOpenFileTypes)
          .snapshotProvider([FileVersionSnapshotterFactory()])

          .registerSystems(configuration.systems)
      #else
        return self.modelContainer(configuration.modelContainer)
          // .onboardingWindow(OnboardingView.self)
          .hubView(configuration.hubView(_:))
          .installerImageRepository(configuration.installerImageRepository)
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .registerSystems(configuration.systems)
      #endif
    }
  }
#endif
