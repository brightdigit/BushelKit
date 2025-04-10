//
//  LibraryError.swift
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

internal import BushelFoundation
public import BushelLogging
public import Foundation

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif

/// An error that represents a problem with a library.
public struct LibraryError: LocalizedError, Loggable {
  /// Represents details about the phase of an image import operation.
  public struct ImageImportDetails {
    /// The phase of the image import operation.
    public enum Phase {
      case copy
      case updateMetadata
    }

    /// The phase of the image import operation.
    public let phase: Phase
    /// The URL of the image being imported.
    public let imageURL: URL
    /// The URL of the library where the image is being imported.
    public let libraryURL: URL
  }

  /// Represents initialization properties that are deprecated.
  @available(*, deprecated)
  public enum InitializationProperty: Sendable {
    case bookmarkData
    case database
    case librarySystemManager
    case sigVerificationManaging
  }

  /// The logging category for this error.
  public static var loggingCategory: BushelLogging.Category {
    .library
  }

  /// The underlying error that caused this library error.
  public let innerError: (any Error)?
  /// The details of the library error.
  public let details: Details

  /// The localized description of the error.
  public var errorDescription: String? {
    self.details.errorDescription(fromError: self.innerError)
  }

  /// The localized recovery suggestion for the error.
  public var recoverySuggestion: String? {
    self.details.recoverySuggestion(fromError: self.innerError)
  }

  /// A Boolean value indicating whether the error is recoverable.
  public var isRecoverable: Bool {
    self.details.isRecoverable(fromError: self.innerError)
  }

  /// Initializes a `LibraryError` instance with the given inner error and details.
  ///
  /// - Parameters:
  ///   - innerError: The underlying error that caused this library error.
  ///   - _: The type of the inner error.
  ///   - details: The details of the library error.
  /// - Throws: The original inner error if it cannot be cast to the expected type.
  private init<TypedError: Error>(
    innerError: any Error,
    as _: TypedError.Type,
    details: LibraryError.Details
  ) throws {
    guard let innerError = innerError as? TypedError else {
      throw innerError
    }
    self.init(details: details, innerError: innerError)
  }

  /// Initializes a `LibraryError` instance with the given details and optional inner error.
  ///
  /// - Parameters:
  ///   - details: The details of the library error.
  ///   - innerError: The optional underlying error that caused this library error.
  private init(
    details: LibraryError.Details,
    innerError: (any Error)? = nil
  ) {
    if let innerError = innerError as? LibraryError {
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

extension LibraryError {
  /// Creates a `LibraryError` instance for a bookmark error.
  ///
  /// - Parameter error: The underlying error that caused the bookmark error.
  /// - Throws: The original inner error if it cannot be cast to the expected type.
  public static func bookmarkError(_ error: any Error) throws -> LibraryError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  /// Creates a `LibraryError` instance for an access denied error at a specific URL.
  ///
  /// - Parameters:
  ///   - error: The optional underlying error that caused the access denied error.
  ///   - url: The URL where the access denied error occurred.
  public static func accessDeniedError(_ error: (any Error)?, at url: URL) -> LibraryError {
    LibraryError(details: .accessDeniedLibraryAt(url), innerError: error)
  }

  /// Creates a `LibraryError` instance for a corrupted image error at a specific URL.
  ///
  /// - Parameters:
  ///   - error: The underlying error that caused the image corruption.
  ///   - url: The URL of the corrupted image.
  public static func imageCorruptedError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .imageCorruptedAt(url), innerError: error)
  }

  /// Creates a `LibraryError` instance for a corrupted library error at a specific URL.
  ///
  /// - Parameters:
  ///   - error: The underlying error that caused the library corruption.
  ///   - url: The URL of the corrupted library.
  public static func libraryCorruptedError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .libraryCorruptedAt(url), innerError: error)
  }

  /// Creates a `LibraryError` instance for an error initializing the images folder at a specific URL.
  ///
  /// - Parameters:
  ///   - error: The underlying error that caused the images folder initialization error.
  ///   - url: The URL of the images folder.
  public static func imagesFolderError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .imageFolderInitializationAt(url), innerError: error)
  }

  /// Creates a `LibraryError` instance for a missing initialized property error.
  ///
  /// - Parameter property: The initialization property that is missing.
  @available(*, deprecated)
  public static func missingInitializedProperty(_ property: InitializationProperty) -> LibraryError
  {
    LibraryError(details: .missingInitialization(for: property))
  }

  /// Creates a `LibraryError` instance for a metadata update error at a specific URL.
  ///
  /// - Parameters:
  ///   - error: The underlying error that caused the metadata update error.
  ///   - url: The URL where the metadata update error occurred.
  @available(*, deprecated)
  public static func metadataUpdateError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .updateMetadataAt(url), innerError: error)
  }

  @available(*, deprecated)
  public static func fromDatabaseError(_ error: any Error) -> LibraryError {
    LibraryError(details: .database, innerError: error)
  }

  public static func copyFrom(
    _ importingURL: URL,
    to libraryURL: URL,
    withError error: any Error
  ) -> LibraryError {
    LibraryError(
      details: .copyImage(
        source: importingURL,
        destination: libraryURL
      ),
      innerError: error
    )
  }

  public static func systemResolutionError(_ error: any Error) throws -> LibraryError {
    try .init(innerError: error, as: VMSystemError.self, details: .systemResolution)
  }
}
