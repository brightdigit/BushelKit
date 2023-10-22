//
// DocumentObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import SwiftData
  import SwiftUI

  @Observable
  class DocumentObject: LoggerCategorized, MachineObjectParent {
    var url: URL?
    var error: MachineError?
    var machineObject: MachineObject?

    var canSaveSnapshot: Bool {
      url != nil && machineObject != nil
    }

    @ObservationIgnored
    var modelContext: ModelContext?

    @ObservationIgnored
    var systemManager: (any MachineSystemManaging)?

    var currentOperation: MachineOperation? {
      get {
        self.machineObject?.currentOperation
      }
      set {
        assert(self.machineObject != nil)
        self.machineObject?.currentOperation = newValue
      }
    }

    var title: String {
      self.machineObject?.entry.name ??
        self.url?
        .deletingPathExtension()
        .lastPathComponent ??
        "Loading Machine..."
    }

    func beginLoadingURL(
      _ url: URL?,
      withContext modelContext: ModelContext,
      restoreImageDBfrom: @escaping (ModelContext) -> InstallerImageRepository,
      snapshotFactory: SnapshotProvider,
      using systemManager: any MachineSystemManaging,
      _ labelProvider: @escaping MetadataLabelProvider
    ) {
      #warning("logging-note: would url ever be nil? if so to log useful message here")
      guard let url else {
        return
      }
      Task {
        await self
          .loadURL(
            url,
            withContext: modelContext,
            restoreImageDBfrom: restoreImageDBfrom,
            snapshotFactory: snapshotFactory,
            using: systemManager,
            labelProvider
          )
      }
    }

    private func loadURL(
      _ url: URL,
      withContext modelContext: ModelContext,
      restoreImageDBfrom: @escaping (ModelContext) -> InstallerImageRepository,
      snapshotFactory: SnapshotProvider,
      using systemManager: any MachineSystemManaging,
      _ labelProvider: @escaping MetadataLabelProvider
    ) async {
      self.modelContext = modelContext
      self.systemManager = systemManager
      do {
        self.machineObject = try await MachineObject(
          parent: self,
          configuration: .init(
            url: url,
            modelContext: modelContext,
            systemManager: systemManager,
            snapshotterFactory: snapshotFactory,
            installerImageRepositoryFrom: restoreImageDBfrom,
            labelProvider: labelProvider
          )
        )
        self.url = url
      } catch {
        Self.logger.error("Could not open \(url, privacy: .public): \(error, privacy: .public)")

        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }

    #warning("logging-note: I am afraid the error is not handled by UI, can we log meaning error here too.")
    func beginSavingSnapshot(_ request: SnapshotRequest) {
      guard let url = self.url else {
        let error = MachineError.missingProperty(.url)
        assertionFailure(error: error)
        self.error = error
        return
      }
      guard let machine = self.machineObject else {
        let error = MachineError.missingProperty(.machine)
        assertionFailure(error: error)
        self.error = error
        return
      }
      machine.beginSavingSnapshot(request, at: url)
    }
  }

#endif
