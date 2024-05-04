//
// VirtualizationMachine+SnapshotAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)

  extension VirtualizationMachine {
    func prepareForSnapshot() async throws -> PreviousAction? {
      if machine.canPause {
        try await machine.pause()
        return .pause
      } else if machine.canStart {
        try await machine.start()
        try await machine.pause()
        return .start
      } else {
        return nil
      }
    }

    func resumeFromPreviousAction(_ action: PreviousAction?) async throws {
      switch action {
      case .pause:
        try await machine.resume()

      case .start:
        try await machine.stop()

      default:
        break
      }
    }
  }

#endif
