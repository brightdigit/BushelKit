//
// InstallerObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelMachine
  import Foundation

  @Observable
  final class InstallerObject: Sendable {
    private let builder: any MachineBuilder

    var url: URL {
      builder.url
    }

    private(set) var percentCompleted: Double = 0.0
    var id: UUID?

    internal init(builder: any MachineBuilder, percentCompleted: Double = 0.0) {
      self.builder = builder
      // self.result = result
      self.percentCompleted = percentCompleted
      self.id = self.builder.observePercentCompleted { percentCompleted in
        Task { @MainActor in
          #warning("logging-note: should we log here?")
          self.percentCompleted = percentCompleted
        }
      }
    }

    @MainActor
    func build() async throws {
      try await self.builder.build()
    }

    deinit {
      if let id {
        #warning("logging-note should we log here?")
        self.builder.removeObserver(id)
      }
    }
  }
#endif
