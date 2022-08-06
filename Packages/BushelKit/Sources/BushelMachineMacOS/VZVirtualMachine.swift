//
// VZVirtualMachine.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import BushelMachine
import Foundation
import Virtualization

extension VZVirtualMachine: MachineSession {
  @MainActor
  public func begin() async throws {
    try await withCheckedThrowingContinuation { continuation in

      self.start { result in
        continuation.resume(with: result)
      }
    }
  }
}
