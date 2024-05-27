//
// SynchronousTask+Box.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

extension SynchronousTask {
  internal class Wait: Sendable {
    internal init(till timeout: DispatchTime = .distantFuture) {
      self.timeout = timeout
    }

    var result: Result<T, any Error>?
    let timeout: DispatchTime
    func `for`(_ closure: @Sendable @escaping () async throws -> T) -> Result<T, any Error>? {
      let semaphore: DispatchSemaphore = .init(value: 0)

      _ = withUnsafeMutablePointer(to: &result) { _ in
        Task {
          self.result = await Result {
            try await closure()
          }
          semaphore.signal()
        }
      }
      let timeoutResult = semaphore.wait(timeout: timeout)

      if case .timedOut = timeoutResult {
        return .failure(TimeoutError(timeout: timeout))
      }
      return result
    }
  }
}
