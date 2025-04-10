//
//  Result.swift
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

extension Result {
  /// Initializes a `Result` by catching any errors thrown by the provided asynchronous closure.
  /// - Parameter body: An asynchronous closure that may throw an error.
  /// - Returns: A `Result` instance containing the success value or the thrown error.
  public init(catching body: @Sendable () async throws -> Success) async
  where Failure == any Error {
    do {
      self = try await .success(body())
    } catch {
      self = .failure(error)
    }
  }

  /// Unwraps the success value of the current `Result` instance,
  /// or returns a new `Result` with the provided failure value if the success value is `nil`.
  /// - Parameter failure: The failure value to be used if the success value is `nil`.
  /// - Returns: A new `Result` instance with the unwrapped success value or the provided failure value.
  public func unwrap<NewSuccess>(
    or failure: Failure
  ) -> Result<NewSuccess, Failure> where Success == NewSuccess? {
    self.flatMap { value in
      if let value {
        .success(value)
      } else {
        .failure(failure)
      }
    }
  }
}
