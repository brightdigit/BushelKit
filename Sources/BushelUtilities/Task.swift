//
//  Task.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

internal import Foundation

/// Extends the `Task` type where the `Success` type is `Never` and the `Failure` type is also `Never`.
extension Task where Success == Never, Failure == Never {
  /// Sleeps the current task for a random duration of seconds
  /// between the specified `value` and `otherValue` parameters,
  /// with a tolerance of up to half the range between the minimum and maximum values.
  ///
  /// - Parameters:
  ///   - value: The first value used to determine the range of seconds to sleep.
  ///   - otherValue: The second value used to determine the range of seconds to sleep.
  ///   - onError: A closure that is called if an error occurs while sleeping the task.
  public static func sleepForSecondsBetween(
    _ value: Int,
    and otherValue: Int,
    _ onError: @escaping @Sendable (any Error) -> Void
  ) async {
    let minimumSeconds = min(value, otherValue)
    let maximumSeconds = max(value, otherValue)

    let range = maximumSeconds - minimumSeconds

    do {
      if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
        let toleranceSeconds: Int
        let durationSeconds: Int
        toleranceSeconds = Int.random(in: 1...(range / 2))

        durationSeconds = .random(in: minimumSeconds...(maximumSeconds - toleranceSeconds))
        try await Self.sleep(
          for: .seconds(durationSeconds),
          tolerance: .seconds(toleranceSeconds)
        )
      } else {
        let nanoSecondsInSeconds: UInt64 = 1_000_000_000
        let minimumNanoSeconds: UInt64 = UInt64(minimumSeconds) * nanoSecondsInSeconds
        let maximumNanoSeconds: UInt64 = UInt64(maximumSeconds) * nanoSecondsInSeconds
        await Self.sleep(.random(in: minimumNanoSeconds...maximumNanoSeconds))
      }
    } catch {
      assertionFailure(error: error, disableAssertionFailureForError: false)
      onError(error)
    }
  }
}

/// Extends the `Task` type where the `Success` type is `Void` and the `Failure` type is `Never`.
extension Task where Success == Void, Failure == Never {
  /// Awaits the completion of the task.
  public func callAsFunction() async {
    await self.value
  }
}

/// Extends the `Task` type where the `Success` type is `Void`.
extension Task where Success == Void {
  /// Awaits the completion of the task and throws any errors that occur.
  public func callAsFunction() async throws {
    try await self.value
  }
}
