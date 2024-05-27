//
// SynchronousTask.swift
// Copyright (c) 2024 BrightDigit.
//

import Dispatch

internal actor SynchronousTask<T: Sendable>: Sendable {
  let timeout: DispatchTime
  let closure: @Sendable () async throws -> T

  internal init(
    timeout: DispatchTime = .distantFuture,
    closure: @escaping @Sendable () async throws -> T
  ) {
    self.timeout = timeout
    self.closure = closure
  }

  nonisolated func run() throws -> T {
    guard let result = Wait(till: timeout).for(self.closure) else {
      assertionFailure("Timeout not handled")
      throw TimeoutError(timeout: timeout)
    }

    return try result.get()
  }
}

internal func wait<T: Sendable>(
  _ timeout: DispatchTime = .distantFuture,
  for closure: @escaping @Sendable () async throws -> T
) throws -> T {
  try SynchronousTask(timeout: timeout, closure: closure).run()
}
