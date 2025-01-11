//
//  MachineError.swift
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

public import BushelFoundation
public import BushelLogging
public import Foundation

// swiftlint:disable file_length

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif
/// Represents an error that occurred within the machine context.
public struct MachineError: LocalizedError, Loggable, Sendable {
  /// Represents a property of an object that can cause an error.
  public enum ObjectProperty: Sendable {
    case url
    case machine
    case snapshot
  }

  /// Represents an error that occurred during the export of a screenshot.
  public struct ScreenshotExportError: Error {
    private let fileNameErrors: [String: Error]

    fileprivate init(fileNameErrors: [String: any Error]) {
      self.fileNameErrors = fileNameErrors
    }
  }

  /// The logging category for this error.
  public static var loggingCategory: BushelLogging.Category {
    .library
  }

  /// The underlying error that caused this error, if any.
  public let innerError: (any Error)?
  /// The details of the error.
  public let details: Details

  /// The localized description of the error.
  public var errorDescription: String? {
    self.details.errorDescription(fromError: self.innerError)
  }

  /// The localized recovery suggestion for the error.
  public var recoverySuggestion: String? {
    self.details.recoverySuggestion(fromError: self.innerError)
  }

  /// A boolean indicating whether the error is recoverable.
  public var isRecoverable: Bool {
    self.details.isRecoverable(fromError: self.innerError)
  }

  /// A boolean indicating whether the error is critical.
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

  /// Initializes a `MachineError` with the given inner error and details.
  ///
  /// - Parameters:
  ///   - innerError: The underlying error that caused this error.
  ///   - _: The type of the inner error.
  ///   - details: The details of the error.
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

  /// Initializes a `MachineError` with the given details and optional inner error.
  ///
  /// - Parameters:
  ///   - details: The details of the error.
  ///   - innerError: The underlying error that caused this error, if any.
  private init(details: MachineError.Details, innerError: (any Error)? = nil) {
    if let innerError = innerError as? MachineError {
      assertionFailure(
        "Creating RestoreLibraryError \(details) within RestoreLibraryError: \(innerError)"
      )
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
  /// Creates a `MachineError` from a session action error.
  ///
  /// - Parameter error: The error that occurred during a session action.
  /// - Returns: A `MachineError` representing the session action error.
  public static func fromSessionAction(error: any Error) -> MachineError {
    if let error = error as? MachineError {
      error
    } else {
      .init(details: .session, innerError: error)
    }
  }

  /// Creates a `MachineError` from an error that occurred during the export of a snapshot.
  ///
  /// - Parameter error: The error that occurred during the export of a snapshot.
  /// - Returns: A `MachineError` representing the snapshot export error.
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

  /// Creates an error representing a snapshot error.
  ///
  /// - Parameter error: The error that occurred during a snapshot operation.
  /// - Returns: The error representing the snapshot error.
  public static func fromSnapshotError(_ error: any Error) -> any Error {
    if error is MachineError {
      error
    } else if error is SnapshotError {
      MachineError(details: .snapshot, innerError: error)
    } else {
      error
    }
  }

  /// Creates a `MachineError` representing a missing property.
  ///
  /// - Parameter property: The property that is missing.
  /// - Returns: A `MachineError` representing the missing property.
  public static func missingProperty(_ property: ObjectProperty) -> MachineError {
    .init(details: .missingProperty(property))
  }

  /// Creates a `MachineError` from a `BookmarkError`.
  ///
  /// - Parameter error: The `BookmarkError` that occurred.
  /// - Returns: A `MachineError` representing the bookmark error.
  public static func bookmarkError(_ error: BookmarkError) -> MachineError {
    .init(details: .bookmarkError, innerError: error)
  }

  /// Creates a `MachineError` from an error that can be cast to `BookmarkError`.
  ///
  /// - Parameter error: The error that can be cast to `BookmarkError`.
  /// - Returns: A `MachineError` representing the bookmark error.
  public static func bookmarkError(_ error: any Error) throws -> MachineError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  /// Creates a `MachineError` representing an access denied error at a specific URL.
  ///
  /// - Parameters:
  ///   - error: The error that occurred, if any.
  ///   - url: The URL where the access was denied.
  /// - Returns: A `MachineError` representing the access denied error.
  public static func accessDeniedError(_ error: (any Error)?, at url: URL) -> MachineError {
    MachineError(details: .accessDeniedLibraryAt(url), innerError: error)
  }

  /// Creates a `MachineError` representing a corrupted error at a specific URL.
  ///
  /// - Parameters:
  ///   - error: The error that occurred.
  ///   - url: The URL where the corruption occurred.
  /// - Returns: A `MachineError` representing the corrupted error.
  public static func corruptedError(_ error: any Error, at url: URL) -> MachineError {
    MachineError(details: .corruptedAt(url), innerError: error)
  }

  /// Creates a `MachineError` from a database error.
  ///
  /// - Parameter error: The error that occurred in the database.
  /// - Returns: A `MachineError` representing the database error.
  public static func fromDatabaseError(_ error: any Error) -> MachineError {
    MachineError(details: .database, innerError: error)
  }

  /// Creates a `MachineError` representing a not found error for a specific bookmark ID.
  ///
  /// - Parameter bookmarkID: The ID of the bookmark that was not found.
  /// - Returns: A `MachineError` representing the not found error.
  public static func notFound(bookmarkID: UUID) -> MachineError {
    .init(details: .notFoundBookmarkID(bookmarkID))
  }

  public static func captureError(_ error: any Error) -> MachineError {
    MachineError(details: .captureError, innerError: error)
  }

  public static func captureUpdateError(_ error: any Error, id: UUID) -> MachineError {
    MachineError(details: .captureUpdateError(id), innerError: error)
  }

  public static func exportScreenshotsError(_ error: any Error, at url: URL) -> MachineError {
    MachineError(details: .exportScreenshotsErrorAt(url), innerError: error)
  }

  public static func exportScreenshots(errors: [String: any Error], at url: URL) -> MachineError {
    MachineError(
      details: .exportScreenshotsErrorAt(url),
      innerError: ScreenshotExportError(fileNameErrors: errors)
    )
  }

  public static func deleteCapturedImage(withID id: UUID, isEmpty: Bool = false) -> MachineError {
    MachineError(details: .missingImage(id))
  }

  public static func deleteCapturedVideo(withID id: UUID, isEmpty: Bool = false) -> MachineError {
    MachineError(details: .missingImage(id))
  }
}
