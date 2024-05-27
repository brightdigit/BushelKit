//
// InstallerObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import Foundation

  @MainActor
  @Observable
  internal final class InstallerObject: Sendable, MachineBuilderObserver, Loggable {
    nonisolated static var loggingCategory: BushelLogging.Category {
      .observation
    }

    private let builder: any MachineBuilder

    internal var url: URL {
      builder.url
    }

    internal private(set) var fractionCompleted: Double?

    internal private(set) var percentTextValue: Int = 0

    internal private(set) var textLocalizedID: LocalizedID = LocalizedStringID.installerTextAuthorizing

    internal var id: UUID?

    @MainActor
    internal init(builder: any MachineBuilder, fractionCompleted: Double? = nil) {
      self.builder = builder
      self.fractionCompleted = fractionCompleted
      self.id = self.builder.observePercentCompleted { newPercent in
        self.updatePercentCompleted(newPercent)
      }
    }

    func getID() async -> UUID? {
      self.id
    }

    nonisolated func updatePercentCompleted(_ value: Double) {
      let newValue = value > 0 ? value : nil
      Task { @MainActor in
        self.setPercentCompleted(value: newValue)
      }
    }

    @MainActor
    func setPercentCompleted(value: Double?) {
      guard let value else {
        self.textLocalizedID = LocalizedStringID.installerTextAuthorizing
        return
      }
      assert(value > 0)
      if let fractionCompleted {
        guard fractionCompleted < value else {
          return
        }
      }
      self.fractionCompleted = value
      self.percentTextValue = Int(value * 100.0)
      self.textLocalizedID = value >= 1.0 ?
        LocalizedStringID.installerTextCompleting :
        LocalizedStringID.installerTextProgress
    }

    @Sendable
    internal func build() async throws {
      try await self.builder.build()
    }

    deinit {
      self.builder.removeObserver(self)
    }
  }
#endif
