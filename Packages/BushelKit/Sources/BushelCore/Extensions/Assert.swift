//
// Assert.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

@inlinable
public func assertionFailure(error: Error, file: StaticString = #file, line: UInt = #line) {
  guard !EnvironmentConfiguration.shared.disableAssertionFailureForError else {
    return
  }
  assertionFailure(error.localizedDescription, file: file, line: line)
}

@inlinable
public func assertionFailure<NewFailure: LocalizedError>(
  error: Error,
  _ unknownError: @escaping (Error) -> Void,
  file: StaticString = #file,
  line: UInt = #line
) -> NewFailure? {
  guard let newError = error as? NewFailure else {
    BushelCore.assertionFailure(error: error, file: file, line: line)
    unknownError(error)
    return nil
  }
  assertionFailure(error: newError, file: file, line: line)
  return newError
}

@inlinable
public func assertionFailure<Success, NewFailure: LocalizedError>(
  result: Result<Success, some Any>,
  file: StaticString = #file,
  line: UInt = #line
) throws -> Result<Success, NewFailure> {
  switch result {
  case let .success(value):
    return .success(value)

  case let .failure(error):
    switch error as? NewFailure {
    case .none:
      assertionFailure(error.localizedDescription, file: file, line: line)
      throw error

    case let .some(newError):
      return .failure(newError)
    }
  }
}
