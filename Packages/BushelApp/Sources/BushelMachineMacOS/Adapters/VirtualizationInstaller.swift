//
// VirtualizationInstaller.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import Virtualization

  @MainActor
  internal class VirtualizationInstaller: Loggable {
    internal nonisolated static var loggingCategory: BushelLogging.Category {
      .machine
    }

    private var result: Result<VZMacOSInstaller, any Error>?

    private var installer: VZMacOSInstaller {
      get throws {
        assert(result != nil)
        switch self.result {
        case .none:
          throw BuilderError.missingInitialization
        case let .failure(error):
          assertionFailure(error: error)
          throw BuilderError.fromInstallation(error: error)
        case let .success(installer):
          return installer
        }
      }
    }

    internal nonisolated init(installer: @Sendable @escaping () throws -> VZMacOSInstaller) {
      Task { @MainActor in
        self.result = Result { try installer() }
      }
    }

    internal func build() async throws {
      let installer = try self.installer
      try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
        installer.install(completionHandler: continuation.resume(with:))
      }
    }

    internal func observe(_ onUpdate: @Sendable @escaping (Double) -> Void) -> NSKeyValueObservation? {
      guard let installer = try? self.installer else {
        return nil
      }
      let observation = installer.progress.observe(
        \.fractionCompleted,
        options: [.new, .initial]
      ) { progress, _ in
        Self.logger.debug("Installation at \(progress.fractionCompleted)")
        onUpdate(progress.fractionCompleted)
      }
      return observation
    }
  }

#endif
