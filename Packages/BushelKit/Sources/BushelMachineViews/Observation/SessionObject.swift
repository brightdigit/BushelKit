//
// SessionObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelSessionUI
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif

  @Observable
  class SessionObject: LoggerCategorized, MachineObjectParent {
    var url: URL?
    var presentConfirmCloseAlert: Bool = false

    var state: MachineState {
      self.machineObject?.state ?? .stopped
    }

    var canStart: Bool {
      self.machineObject?.canStart ?? false
    }

    var canStop: Bool {
      self.machineObject?.canStop ?? false
    }

    var canPause: Bool {
      self.machineObject?.canPause ?? false
    }

    var canResume: Bool {
      self.machineObject?.canResume ?? false
    }

    var canRequestStop: Bool {
      self.machineObject?.canRequestStop ?? false
    }

    var machineObject: MachineObject?
    var error: MachineError?

    @ObservationIgnored
    var windowClose: NSWindowDelegate?

    #if canImport(SwiftUI)
      func view() -> some View {
        machineObject?.sessionViewable?.anyView()
      }
    #endif

    func loadURL(
      _ url: URL,
      withContext modelContext: ModelContext,
      restoreImageDBfrom: @escaping (ModelContext) -> InstallerImageRepository,
      snapshotFactory: SnapshotProvider,
      using systemManager: any MachineSystemManaging,

      labelProvider: @escaping MetadataLabelProvider
    ) async {
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

    func begin(_ closure: @escaping (any BushelMachine.Machine) async throws -> Void) {
      guard let machine = machineObject?.machine else {
        assertionFailure("Missing machine to start with.")
        return
      }
      Task {
        @MainActor in
        do {
          try await closure(machine)
        } catch let error as MachineError {
          self.error = error
        } catch {
          assertionFailure(error: error)
        }
      }
    }

    func beginShutdown() {
      self.begin {
        try await $0.requestStop()
      }
    }

    func shouldCloseWindow(_: NSWindow) -> Bool {
      if self.machineObject?.state == .stopped || self.machineObject == nil {
        return true
      } else {
        self.presentConfirmCloseAlert = true
        return false
      }
    }

    func beginSnapshot() {
      guard let machine = machineObject?.machine else {
        assertionFailure("Missing machine or url.")
        return
      }

      Task {
        if machine.canPause {
          do {
            try await machine.pause()
          } catch let error as MachineError {
            self.error = error
          } catch {
            assertionFailure(error: error)
          }
        }
      }
    }
  }
#endif
