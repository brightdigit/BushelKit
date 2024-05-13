//
//  MachineError.swift
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

import BushelCore
import BushelLogging
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct MachineError: LocalizedError, Loggable {
  public enum ObjectProperty: Sendable {
    case url
    case machine
    case snapshot
  }

  public static var loggingCategory: BushelLogging.Category {
    .library
  }

  public let innerError: (any Error)?
  public let details: Details

  public var errorDescription: String? {
    details.errorDescription(fromError: innerError)
  }

  public var recoverySuggestion: String? {
    details.recoverySuggestion(fromError: innerError)
  }

  public var isRecoverable: Bool {
    details.isRecoverable(fromError: innerError)
  }

  public var isCritical: Bool {
    switch self.details {
    case .corruptedAt:
      true

    case .session:
      true

    default:
      false
    }
  }

  private init<TypedError: Error>(
    innerError: any Error,
    as _: TypedError.Type,
    details: MachineError.Details
  ) throws {
    guard let innerError = innerError as? TypedError else {
      throw innerError
    }
    self.init(details: details, innerError: innerError)
  }

  private init(details: MachineError.Details, innerError: (any Error)? = nil) {
    if let innerError = innerError as? MachineError {
      assertionFailure("Creating RestoreLibraryError \(details) within RestoreLibraryError: \(innerError)")
      Self.logger.critical(
        // swiftlint:disable:next line_length
        "Creating RestoreLibraryError \(details.errorDescription(fromError: innerError)) within RestoreLibraryError: \(innerError)"
      )
    }
    self.innerError = innerError
    self.details = details
  }
}

extension MachineError {
  public static func fromSessionAction(error: any Error) -> MachineError {
    if let error = error as? MachineError {
      error
    } else {
      .init(details: .session, innerError: error)
    }
  }

  public static func fromExportSnapshotError(_ error: any Error) -> MachineError {
    if let error = error as? MachineError {
      error
    } else if error is SnapshotError {
      MachineError(details: .snapshot, innerError: error)
    } else if let error = error as? BookmarkError {
      .bookmarkError(error)
    } else {
      .fromDatabaseError(error)
    }
  }

  public static func fromSnapshotError(_ error: any Error) -> any Error {
    if error is MachineError {
      error
    } else if error is SnapshotError {
      MachineError(details: .snapshot, innerError: error)
    } else {
      error
    }
  }

  public static func missingProperty(_ property: ObjectProperty) -> MachineError {
    .init(details: .missingProperty(property))
  }

  public static func bookmarkError(_ error: BookmarkError) -> MachineError {
    .init(details: .bookmarkError, innerError: error)
  }

  public static func bookmarkError(_ error: any Error) throws -> MachineError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  public static func accessDeniedError(_ error: (any Error)?, at url: URL) -> MachineError {
    MachineError(details: .accessDeniedLibraryAt(url), innerError: error)
  }

  public static func corruptedError(_ error: any Error, at url: URL) -> MachineError {
    MachineError(details: .corruptedAt(url), innerError: error)
  }

  public static func fromDatabaseError(_ error: any Error) -> MachineError {
    MachineError(details: .database, innerError: error)
  }
}
