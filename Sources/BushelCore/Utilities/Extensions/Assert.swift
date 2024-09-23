//
//  Assert.swift
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

public import Foundation

@inlinable public func assert(isMainThread: Bool) { assert(isMainThread == Thread.isMainThread) }

@inlinable public func assertionFailure(
  error: any Error,
  file: StaticString = #file,
  line: UInt = #line
) {
  guard !EnvironmentConfiguration.shared.disableAssertionFailureForError else { return }
  assertionFailure(error.localizedDescription, file: file, line: line)
}

@inlinable public func assertionFailure<NewFailure: LocalizedError>(
  error: any Error,
  _ unknownError: @escaping (any Error) -> Void,
  file: StaticString = #file,
  line: UInt = #line
) -> NewFailure? {
  guard let newError = error as? NewFailure else {
    BushelCore.assertionFailure(error: error, file: file, line: line)
    unknownError(error)
    return nil
  }
  BushelCore.assertionFailure(error: newError, file: file, line: line)
  return newError
}

@inlinable public func assertionFailure<Success, NewFailure: LocalizedError>(
  result: Result<Success, some Any>,
  file: StaticString = #file,
  line: UInt = #line
) throws -> Result<Success, NewFailure> {
  switch result {
  case let .success(value): return .success(value)

  case let .failure(error):
    switch error as? NewFailure {
    case .none:
      assertionFailure(error.localizedDescription, file: file, line: line)
      throw error

    case let .some(newError): return .failure(newError)
    }
  }
}
