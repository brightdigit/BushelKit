//
// MachineError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct MachineError: LocalizedError, Loggable {
  public enum ObjectProperty {
    case url
    case machine
    case snapshot
  }

  public static var loggingCategory: BushelLogging.Category {
    .library
  }

  let innerError: (any Error)?
  let details: Details

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

public extension MachineError {
  static func fromSessionAction(error: any Error) -> MachineError {
    if let error = error as? MachineError {
      error
    } else {
      .init(details: .session, innerError: error)
    }
  }

  static func fromExportSnapshotError(_ error: any Error) -> MachineError {
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

  static func fromSnapshotError(_ error: any Error) -> any Error {
    if error is MachineError {
      error
    } else if error is SnapshotError {
      MachineError(details: .snapshot, innerError: error)
    } else {
      error
    }
  }

  static func missingProperty(_ property: ObjectProperty) -> MachineError {
    .init(details: .missingProperty(property))
  }

  static func bookmarkError(_ error: BookmarkError) -> MachineError {
    .init(details: .bookmarkError, innerError: error)
  }

  static func bookmarkError(_ error: any Error) throws -> MachineError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  static func accessDeniedError(_ error: (any Error)?, at url: URL) -> MachineError {
    MachineError(details: .accessDeniedLibraryAt(url), innerError: error)
  }

  static func corruptedError(_ error: any Error, at url: URL) -> MachineError {
    MachineError(details: .corruptedAt(url), innerError: error)
  }

  static func fromDatabaseError(_ error: any Error) -> MachineError {
    MachineError(details: .database, innerError: error)
  }
}
