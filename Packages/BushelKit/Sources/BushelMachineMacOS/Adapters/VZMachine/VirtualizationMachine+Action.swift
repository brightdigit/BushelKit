//
// VirtualizationMachine+Action.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import Foundation

  extension VirtualizationMachine {
    @MainActor
    func start() async throws {
      try await machine.start()
    }

    @MainActor
    func pause() async throws {
      try await machine.pause()
    }

    @MainActor
    func stop() async throws {
      try await machine.stop()
    }

    @MainActor
    func resume() async throws {
      try await machine.resume()
    }

    @MainActor
    func restoreMachineStateFrom(url saveFileURL: URL) async throws {
      try await self.machine.restoreMachineStateFrom(url: saveFileURL)
    }

    @MainActor
    func saveMachineStateTo(url saveFileURL: URL) async throws {
      try await self.machine.saveMachineStateTo(url: saveFileURL)
    }

    func requestStop() async throws {
      try await MainActor.run {
        try self.machine.requestStop()
      }
    }
  }

#endif
