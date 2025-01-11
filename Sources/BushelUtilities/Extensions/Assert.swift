//
//  Assert.swift
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

public import Foundation

/// Asserts that the current thread is the main thread.
@inlinable
public func assert(isMainThread: Bool) {
  assert(isMainThread == Thread.isMainThread)
}

/// Logs an assertion failure with the provided error's localized description.
///
/// - Parameters:
///   - error: The error that caused the assertion failure.
///   - file: The file where the assertion failure occurred. Defaults to the current file.
///   - line: The line where the assertion failure occurred. Defaults to the current line.
@inlinable
public func assertionFailure(
  error: any Error,
  file: StaticString = #file,
  line: UInt = #line,
  disableAssertionFailureForError: Bool
) {
  guard !disableAssertionFailureForError else {
    return
  }
  assertionFailure(error.localizedDescription, file: file, line: line)
}

/// Logs an assertion failure with the provided error,
/// and optionally passes the error to a custom error handling function.
///
/// - Parameters:
///   - error: The error that caused the assertion failure.
///   - unknownError: A closure that will be called with the error
///   if it cannot be cast to the `NewFailure` type.
///   - file: The file where the assertion failure occurred. Defaults to the current file.
///   - line: The line where the assertion failure occurred. Defaults to the current line.
/// - Returns: The `NewFailure` error, if the `error` parameter can be cast to that type. Otherwise, `nil`.
@inlinable
public func assertionFailure<NewFailure: LocalizedError>(
  error: any Error,
  _ unknownError: @escaping (any Error) -> Void,
  file: StaticString = #file,
  line: UInt = #line,
  disableAssertionFailureForError: Bool
) -> NewFailure? {
  guard let newError = error as? NewFailure else {
    BushelUtilities.assertionFailure(
      error: error,
      file: file,
      line: line,
      disableAssertionFailureForError: disableAssertionFailureForError
    )
    unknownError(error)
    return nil
  }
  BushelUtilities.assertionFailure(
    error: newError,
    file: file,
    line: line,
    disableAssertionFailureForError: disableAssertionFailureForError
  )
  return newError
}

/// Handles the result of an operation, logging an assertion failure if the result is a failure.
///
/// - Parameters:
///   - result: The result of an operation.
///   - file: The file where the assertion failure occurred. Defaults to the current file.
///   - line: The line where the assertion failure occurred. Defaults to the current line.
/// - Returns: The `Success` value if the result was successful,
/// or throws the `NewFailure` error if the result was a failure.
@inlinable
public func assertionFailure<Success, NewFailure: LocalizedError>(
  result: Result<Success, some Any>,
  file: StaticString = #file,
  line: UInt = #line,
  disableAssertionFailureForError: Bool
) throws -> Result<Success, NewFailure> {
  switch result {
  case let .success(value):
    return .success(value)

  case let .failure(error):
    switch error as? NewFailure {
    case .none:
      assertionFailure(
        error: error,
        file: file,
        line: line,
        disableAssertionFailureForError: disableAssertionFailureForError
      )
      throw error

    case let .some(newError):
      return .failure(newError)
    }
  }
}
