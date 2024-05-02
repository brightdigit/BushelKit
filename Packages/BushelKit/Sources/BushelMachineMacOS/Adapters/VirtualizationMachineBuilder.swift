//
// VirtualizationMachineBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelLogging
  import BushelMachine
  import Foundation
  import Virtualization

  final class VirtualizationMachineBuilder: MachineBuilder, Loggable, Sendable {
    static var loggingCategory: BushelLogging.Category {
      .machine
    }

    let url: URL

    private var observations = [UUID: NSKeyValueObservation]()

    let installer: VZMacOSInstaller

    init(url: URL, installer: VZMacOSInstaller) {
      self.url = url
      self.installer = installer
    }

    @MainActor
    func build() async throws {
      let seconds: Int = .random(in: 10 ... 20)
      try await withCheckedThrowingContinuation { continuation in
        Task { @MainActor in
          installer.install { result in
            Task {
              Self.logger.debug("waiting for file lock on auxillary for \(seconds) secs.")
              do {
                try await Task.sleep(for: .seconds(seconds))
              } catch {
                Self.logger.error("Unable to sleep for \(seconds) secs: \(error)")
              }
              continuation.resume(with: result)
            }
          }
        }
      }
    }

    func observePercentCompleted(_ onUpdate: @Sendable @escaping (Double) -> Void) -> UUID {
      let observation = self.installer.progress.observe(
        \.fractionCompleted,
        options: [.new, .initial]
      ) { progress, _ in
        Self.logger.debug("Installlation at \(progress.fractionCompleted)")
        onUpdate(progress.fractionCompleted)
      }
      let id = UUID()
      self.observations[id] = observation
      return id
    }

    func removeObserver(_ id: UUID) -> Bool {
      Self.logger.debug("Removing Observer")
      return self.observations.removeValue(forKey: id) != nil
    }

    deinit {
      self.observations.removeAll()
    }
  }
#endif
