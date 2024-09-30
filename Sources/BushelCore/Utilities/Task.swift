//
//  Task.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

import Foundation

extension Task where Success == Never, Failure == Never {
  public static func sleepForSecondsBetween(
    _ value: Int,
    and otherValue: Int,
    _ onError: @escaping @Sendable (any Error) -> Void
  ) async {
    let toleranceSeconds: Int
    let durationSeconds: Int

    let minimumSeconds = min(value, otherValue)
    let maximumSeconds = max(value, otherValue)

    let range = maximumSeconds - minimumSeconds
    toleranceSeconds = Int.random(in: 1...(range / 2))

    durationSeconds = .random(in: minimumSeconds...(maximumSeconds - toleranceSeconds))

    do {
      try await Self.sleep(
        for: .seconds(durationSeconds),
        tolerance: .seconds(toleranceSeconds)
      )
    } catch {
      assertionFailure(error: error)
      onError(error)
    }
  }
}

extension Task where Success == Void, Failure == Never {
  public func callAsFunction() async {
    await self.value
  }
}

extension Task where Success == Void {
  public func callAsFunction() async throws {
    try await self.value
  }
}
