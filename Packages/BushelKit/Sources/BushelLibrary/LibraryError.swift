//
// LibraryError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct LibraryError: LocalizedError, LoggerCategorized {
  struct ImageImportDetails {
    enum Phase {
      case copy
      case updateMetadata
    }

    let phase: Phase
    let imageURL: URL
    let libraryURL: URL
  }

  public enum InitializationProperty {
    case bookmarkData
    case modelContext
    case librarySystemManager
  }

  enum Details {
    private struct UnknownError: Error {
      private init() {}
      fileprivate static let shared = UnknownError()
    }

    case bookmarkError
    case systemResolution
    case accessDeniedLibraryAt(URL)
    case imageCorruptedAt(URL)
    case libraryCorruptedAt(URL)
    case imageFolderInitializationAt(URL)
    case updateMetadataAt(URL)
    case missingInitialization(for: InitializationProperty)
    case database
    case copyImage(source: URL, destination: URL)

    func errorDescription(fromError error: Error?) -> String {
      switch self {
      case .bookmarkError:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue getting the bookmark: \(error)"

      case .systemResolution:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "Unable to resolve new image: \(error)"

      case let .accessDeniedLibraryAt(at: path):
        let components: [String?] = [
          "There's an issue getting access to library at \(path)", error?.localizedDescription
        ]
        return components.compactMap { $0 }.joined(separator: ": ")

      case let .imageCorruptedAt(at: importingURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue getting the metadata for image at \(importingURL): \(error)"
      case let .libraryCorruptedAt(at: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue reading the library at \(libraryURL): \(error)"
      case let .imageFolderInitializationAt(at: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue prepping the library at \(libraryURL): \(error)"
      case let .updateMetadataAt(at: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "We were unable to update \(libraryURL): \(error)"
      case let .missingInitialization(for: property):
        return "There an issue with this library. Missing \(property)."
      case .database:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There was an issue syncing with the database: \(error)"
      case let .copyImage(source: importingURL, destination: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return
          "There was an error copying the image at \(importingURL) to library at: \(libraryURL): \(error)"
      }
    }

    func recoverySuggestion(fromError _: Error?) -> String? {
      switch self {
      case .accessDeniedLibraryAt(at: _):
        return "Close and open the library again."
      case let .imageCorruptedAt(at: imageURL):
        return "Invalid Restore Image at \(imageURL)"
      case .imageFolderInitializationAt(at: _):
        return "Close and open the library again."
      case .missingInitialization(for: _):
        return "Close and open the library again."
      default:
        return nil
      }
    }

    func isRecoverable(fromError _: Error?) -> Bool {
      switch self {
      case .bookmarkError:
        return false

      case .accessDeniedLibraryAt(at: _):
        return false

      case .imageCorruptedAt(at: _):
        return true

      case .libraryCorruptedAt(at: _):
        return false

      case .imageFolderInitializationAt(at: _):
        return false

      case .updateMetadataAt(at: _):
        return false

      case .missingInitialization(for: _):
        return false

      case .database:
        return false

      case .copyImage:
        return true

      case .systemResolution:
        return false
      }
    }
  }

  public static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }

  let innerError: Error?
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

  fileprivate init<TypedError: Error>(
    innerError: Error,
    as _: TypedError.Type,
    details: LibraryError.Details
  ) throws {
    guard let innerError = innerError as? TypedError else {
      throw innerError
    }
    self.init(innerError: innerError, details: details)
  }

  fileprivate init(
    innerError: Error? = nil,
    details: LibraryError.Details
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

public extension LibraryError {
  static func bookmarkError(_ error: Error) throws -> LibraryError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  static func accessDeniedError(_ error: Error?, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .accessDeniedLibraryAt(url))
  }

  static func imageCorruptedError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .imageCorruptedAt(url))
  }

  static func libraryCorruptedError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .libraryCorruptedAt(url))
  }

  static func imagesFolderError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .imageFolderInitializationAt(url))
  }

  static func missingInitializedProperty(_ property: InitializationProperty) -> LibraryError {
    LibraryError(details: .missingInitialization(for: property))
  }

  static func metadataUpdateError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .updateMetadataAt(url))
  }

  static func fromDatabaseError(_ error: Error) -> LibraryError {
    LibraryError(innerError: error, details: .database)
  }

  static func copyFrom(_ importingURL: URL, to libraryURL: URL, withError error: Error) -> LibraryError {
    LibraryError(innerError: error, details: .copyImage(source: importingURL, destination: libraryURL))
  }

  static func systemResolutionError(_ error: Error) throws -> LibraryError {
    try .init(innerError: error, as: VMSystemError.self, details: .systemResolution)
  }
}
