//
// InstallerObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import BushelMachine
  import Foundation

  @Observable
  class InstallerObject {
    internal init(builder: MachineBuilder, percentCompleted: Double = 0.0) {
      self.builder = builder
      // self.result = result
      self.percentCompleted = percentCompleted
      self.id = self.builder.observePercentCompleted { percentCompleted in
        Task { @MainActor in
          self.percentCompleted = percentCompleted
        }
      }
    }

    private let builder: MachineBuilder

    var url: URL {
      builder.url
    }

    // var result: Result<Void, Error>?

    private(set) var percentCompleted: Double = 0.0
    var id: UUID?

    @MainActor
    func build() async throws {
      try await self.builder.build()
    }

    deinit {
      if let id {
        self.builder.removeObserver(id)
      }
    }
  }
#endif
