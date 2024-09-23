//
//  LibraryError.swift
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
public import BushelLogging
public import Foundation

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif

public struct LibraryError: LocalizedError, Loggable {
  public struct ImageImportDetails {
    public enum Phase {
      case copy
      case updateMetadata
    }

    public let phase: Phase
    public let imageURL: URL
    public let libraryURL: URL
  }

  public enum InitializationProperty: Sendable {
    case bookmarkData
    case database
    case librarySystemManager
  }

  public static var loggingCategory: BushelLogging.Category { .library }

  public let innerError: (any Error)?
  public let details: Details

  public var errorDescription: String? { details.errorDescription(fromError: innerError) }

  public var recoverySuggestion: String? { details.recoverySuggestion(fromError: innerError) }

  public var isRecoverable: Bool { details.isRecoverable(fromError: innerError) }

  private init<TypedError: Error>(
    innerError: any Error,
    as _: TypedError.Type,
    details: LibraryError.Details
  ) throws {
    guard let innerError = innerError as? TypedError else { throw innerError }
    self.init(details: details, innerError: innerError)
  }

  private init(details: LibraryError.Details, innerError: (any Error)? = nil) {
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
  public static func bookmarkError(_ error: any Error) throws -> LibraryError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  public static func accessDeniedError(_ error: (any Error)?, at url: URL) -> LibraryError {
    LibraryError(details: .accessDeniedLibraryAt(url), innerError: error)
  }

  public static func imageCorruptedError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .imageCorruptedAt(url), innerError: error)
  }

  public static func libraryCorruptedError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .libraryCorruptedAt(url), innerError: error)
  }

  public static func imagesFolderError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .imageFolderInitializationAt(url), innerError: error)
  }

  public static func missingInitializedProperty(_ property: InitializationProperty) -> LibraryError
  { LibraryError(details: .missingInitialization(for: property)) }

  public static func metadataUpdateError(_ error: any Error, at url: URL) -> LibraryError {
    LibraryError(details: .updateMetadataAt(url), innerError: error)
  }

  public static func fromDatabaseError(_ error: any Error) -> LibraryError {
    LibraryError(details: .database, innerError: error)
  }

  public static func copyFrom(_ importingURL: URL, to libraryURL: URL, withError error: any Error)
    -> LibraryError
  {
    LibraryError(
      details: .copyImage(source: importingURL, destination: libraryURL),
      innerError: error
    )
  }

  public static func systemResolutionError(_ error: any Error) throws -> LibraryError {
    try .init(innerError: error, as: VMSystemError.self, details: .systemResolution)
  }
}
