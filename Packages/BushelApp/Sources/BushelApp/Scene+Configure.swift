//
// Scene+Configure.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelAnalytics
  import BushelBookmarkService
  import BushelCanary
  import BushelCore
  import BushelData
  import BushelDataCore
  import BushelDataMonitor
  import BushelFeatureFlags
  import BushelFeedbackEnvironment
  import BushelFeedbackViews
  import BushelLogging
  import BushelMachine
  import BushelMarketEnvironment
  import BushelOnboardingCore
  import BushelOnboardingViews
  import BushelSystem
  import BushelViewsCore
  import BushelXPCSession
  import Combine
  import SwiftData
  import SwiftUI

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    @MainActor
    internal func configure<
      MachineFileType: FileTypeSpecification,
      LibraryFileType: InitializableFileTypeSpecification
    >(
      libraryFileType: LibraryFileType.Type,
      machineFileType: MachineFileType.Type,
      @SystemBuilder _ systems: @escaping () -> [any System]
    ) -> some View {
      self.configure(SceneConfiguration<MachineFileType, LibraryFileType>(systems))
    }

    @MainActor internal func configure(
      _ configuration: some ApplicationConfiguration
    ) -> some View {
      #if os(macOS)
        self
          .database(configuration.database)
          .modelContainer(configuration.modelContainer)
          .environment(\.databaseChangePublicist, .init(dbWatcher: DataMonitor.shared))
          .hubView {
            configuration.hubView($0)
          }
          .openFileURL { configuration.openFileURL($0, openWindow: $1) }
          .newLibrary(type(of: configuration).LibraryFileType)
          .openMachine(type(of: configuration).MachineFileType)
          .allowedOpenFileTypes(configuration.allowedOpenFileTypes)
          .registerSystems(configuration.systems)
      #else
        self
          .modelContainer(configuration.modelContainer)
          .hubView { configuration.hubView($0) }
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .registerSystems(configuration.systems)
      #endif
    }
  }

  #if os(macOS)
    extension Scene {
      public func onboardingWindow<SingleWindowViewType: SingleWindowView>(
        _ view: SingleWindowViewType.Type
      ) -> some Scene where SingleWindowViewType.Value == OnboardingWindowValue {
        self.environment(\.onboardingWindow, view.Value.default)
      }
    }
  #endif

  extension Scene {
    public func provideFeedback<SingleWindowViewType: SingleWindowView>(
      _ view: SingleWindowViewType.Type
    ) -> some Scene where SingleWindowViewType.Value == ProvideFeedbackWindowValue {
      self.environment(\.provideFeedback, view.Value.default)
    }
  }

  extension Scene {
    private static func setupDatabaseMonitor(_ configuration: some ApplicationConfiguration) {
      var registrations = [any AgentRegister]()
      registrations.append(BookmarkService(database: configuration.database))
      DataMonitor.shared.begin(with: registrations)
    }

    private static func setupEnvironment(configuration: some ApplicationConfiguration) {
      let logger = BushelLogging.logger(forCategory: .application)
      if EnvironmentConfiguration.shared.resetApplication {
        logger.debug("Clearing application data")
        do {
          try Bundle.main.clearUserDefaults()
          try FileManager.default.clearSavedApplicationState()
          configuration.modelContainer.deleteAllData()
          logger.debug("Clearing completed")
        } catch {
          logger.error("Unable to reset application: \(error)")
          assertionFailure(error: error)
        }
      }
    }

    @MainActor
    internal func configure<
      MachineFileType: FileTypeSpecification,
      LibraryFileType: InitializableFileTypeSpecification
    >(
      libraryFileType: LibraryFileType.Type,
      machineFileType: MachineFileType.Type,
      @SystemBuilder _ systems: @escaping @Sendable () -> [any System]
    ) -> some Scene {
      self.configure(SceneConfiguration<MachineFileType, LibraryFileType>(systems))
    }

    @MainActor internal func configure(
      _ configuration: some ApplicationConfiguration
    ) -> some Scene {
      Initialization.begin {
        Self.setupEnvironment(configuration: configuration)
        if UserDefaults.standard.value(for: Tracking.Error.self) {
          Canary.setupErrorTracking()
        }
        Self.setupDatabaseMonitor(configuration)
        PlausibleAnalytics().sendEvent(StartupEvent())
      }

      #if os(macOS)
        return self
          .modelContainer(configuration.modelContainer)
          .database(configuration.database)
          .environment(\.databaseChangePublicist, .init(dbWatcher: DataMonitor.shared))
          .session(configuration.xpcService)
          .provideFeedback(FeedbackView.self)
          .onboardingWindow(FujiFeaturesView.self)
          .hubView {
            configuration.hubView($0)
          }
          .installerImageRepository { configuration.installerImageRepository($0) }
          .openFileURL { configuration.openFileURL($0, openWindow: $1) }
          .newLibrary(type(of: configuration).LibraryFileType)
          .openLibrary(type(of: configuration).LibraryFileType)
          .openMachine(type(of: configuration).MachineFileType)
          .allowedOpenFileTypes(configuration.allowedOpenFileTypes)
          .snapshotProvider([FileVersionSnapshotterFactory()])
          .registerSystems(configuration.systems)
      #else
        return self.modelContainer(configuration.modelContainer)
          .hubView { configuration.hubView($0) }
          .installerImageRepository(configuration.installerImageRepository)
          .openFileURL(configuration.openFileURL(_:openWindow:))
          .registerSystems(configuration.systems)
      #endif
    }
  }
#endif
