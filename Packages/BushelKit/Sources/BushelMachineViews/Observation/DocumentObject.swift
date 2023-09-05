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
  class DocumentObject: LoggerCategorized {
    var url: URL?
    var error: MachineError?
    var machineObject: MachineObject?

    @ObservationIgnored
    var modelContext: ModelContext?

    @ObservationIgnored
    var systemManager: (any MachineSystemManaging)?

    func loadURL(
      _ url: URL,
      withContext modelContext: ModelContext,
      restoreImageDBfrom: @escaping (ModelContext) -> InstallerImageRepository,
      using systemManager: any MachineSystemManaging,
      _ labelProvider: @escaping (VMSystemID, ImageMetadata) -> MetadataLabel
    ) {
      self.modelContext = modelContext
      self.systemManager = systemManager
      do {
        self.machineObject = try MachineObject(
          configuration: .init(url: url, modelContext: modelContext, systemManager: systemManager, installerImageRepositoryFrom: restoreImageDBfrom, labelProvider: labelProvider)
          // url: url, modelContext: modelContext, installerImageRepositoryFrom: restoreImageDBfrom, systemManager: systemManager, labelProvider: labelProvider
        )
        self.url = url
      } catch {
        Self.logger.error("Could not open \(url, privacy: .public): \(error, privacy: .public)")

        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }
  }

#endif
