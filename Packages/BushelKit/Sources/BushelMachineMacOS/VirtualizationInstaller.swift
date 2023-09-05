//
// VirtualizationInstaller.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelLogging
  import BushelMachine
  import Foundation
  import Virtualization

  class VirtualizationInstaller: MachineBuilder, LoggerCategorized {
    static var loggingCategory: Loggers.Category {
      .machine
    }

    typealias LoggersType = Loggers

    let url: URL

    var observations = [UUID: NSKeyValueObservation]()

    let installer: VZMacOSInstaller

    @MainActor
    public func build() async throws {
      try await withCheckedThrowingContinuation { continuation in
        Task { @MainActor in
          installer.install(completionHandler: continuation.resume(with:))
        }
      }
    }

    init(url: URL, installer: VZMacOSInstaller) {
      self.url = url
      self.installer = installer
    }

    public func observePercentCompleted(_ onUpdate: @escaping (Double) -> Void) -> UUID {
      let observation = self.installer.progress.observe(\.fractionCompleted, options: [.new, .initial]) { progress, _ in
        Self.logger.debug("Installlation at \(progress.fractionCompleted)")
        onUpdate(progress.fractionCompleted)
      }
      let id = UUID()
      self.observations[id] = observation
      return id
    }

    func removeObserver(_ id: UUID) -> Bool {
      self.observations.removeValue(forKey: id) != nil
    }

    deinit {
      self.observations.removeAll()
    }
  }
#endif
