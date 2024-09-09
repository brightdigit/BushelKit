//
// AppleVirtualizationMachineBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import Virtualization

  internal final class AppleVirtualizationMachineBuilder: MachineBuilder, Loggable {
    static var loggingCategory: BushelLogging.Category {
      .machine
    }

    let url: URL

    private let observations = ObservationCollection()

    private let installer: AppleVirtualizationInstaller

    init(url: URL, installer: @Sendable @escaping () throws -> VZMacOSInstaller) async {
      self.url = url
      self.installer = await .init(installer: installer)
    }

    func build() async throws {
      try await self.installer.build()
    }

    nonisolated func observePercentCompleted(_ onUpdate: @Sendable @escaping (Double) -> Void) -> UUID {
      let id = UUID()
      Task {
        let observation = await self.installer.observe(onUpdate)
        assert(observation != nil)
        if let observation {
          await observations.append(observation, withID: id)
        }
      }
      return id
    }

    func removeObserver(_ id: UUID) async -> Bool {
      Self.logger.debug("Removing Observer")
      return await self.observations.remove(withID: id)
    }

    deinit {
      self.observations.clear()
    }
  }
#endif
