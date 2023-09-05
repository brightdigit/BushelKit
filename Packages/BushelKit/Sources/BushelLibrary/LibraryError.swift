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
  public static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }

  public typealias LoggersType = BushelLogging.Loggers

  fileprivate init<TypedError: Error>(innerError: Error, as _: TypedError.Type, details: LibraryError.Details) throws {
    guard let innerError = innerError as? TypedError else {
      throw innerError
    }
    self.init(innerError: innerError, details: details)
  }

  fileprivate init(innerError: Error? = nil, details: LibraryError.Details) {
    if let innerError = innerError as? LibraryError {
      assertionFailure("Creating RestoreLibraryError \(details) within RestoreLibraryError: \(innerError)")
      Self.logger.critical("Creating RestoreLibraryError \(details.errorDescription(fromError: innerError)) within RestoreLibraryError: \(innerError)")
    }
    self.innerError = innerError
    self.details = details
  }

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
    case accessDeniedLibrary(at: URL)
    case imageCorrupted(at: URL)
    case libraryCorrupted(at: URL)
    case imageFolderInitialization(at: URL)
    case updateMetadata(at: URL)
    case missingInitialization(for: InitializationProperty)
    case database
    case copyImage(from: URL, to: URL)

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

      case let .accessDeniedLibrary(at: path):
        let components: [String?] = ["There's an issue getting access to library at \(path)", error?.localizedDescription]
        return components.compactMap { $0 }.joined(separator: ": ")

      case let .imageCorrupted(at: importingURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue getting the metadata for image at \(importingURL): \(error)"
      case let .libraryCorrupted(at: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue reading the library at \(libraryURL): \(error)"
      case let .imageFolderInitialization(at: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue prepping the library at \(libraryURL): \(error)"
      case let .updateMetadata(at: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "We were unable to update \(libraryURL): \(error)"
      case let .missingInitialization(for: property):
        return "There an issue with this library. Missing \(property)."
      case .database:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There was an issue syncing with the database: \(error)"
      case let .copyImage(from: importingURL, to: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There was an error copying the image at \(importingURL) to library at: \(libraryURL): \(error)"
      }
    }

    func recoverySuggestion(fromError _: Error?) -> String? {
      switch self {
      case .accessDeniedLibrary(at: _):
        return "Close and open the library again."
      case let .imageCorrupted(at: imageURL):
        return "Invalid Restore Image at \(imageURL)"
      case .imageFolderInitialization(at: _):
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

      case .accessDeniedLibrary(at: _):
        return false

      case .imageCorrupted(at: _):
        return true

      case .libraryCorrupted(at: _):
        return false

      case .imageFolderInitialization(at: _):
        return false

      case .updateMetadata(at: _):
        return false

      case .missingInitialization(for: _):
        return false

      case .database:
        return false

      case .copyImage(from: _, to: _):
        return true

      case .systemResolution:
        return false
      }
    }
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
}

public extension LibraryError {
  static func bookmarkError(_ error: Error) throws -> LibraryError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  static func accessDeniedError(_ error: Error?, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .accessDeniedLibrary(at: url))
  }

  static func imageCorruptedError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .imageCorrupted(at: url))
  }

  static func libraryCorruptedError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .libraryCorrupted(at: url))
  }

  static func imagesFolderError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .imageFolderInitialization(at: url))
  }

  static func missingInitializedProperty(_ property: InitializationProperty) -> LibraryError {
    LibraryError(details: .missingInitialization(for: property))
  }

  static func metadataUpdateError(_ error: Error, at url: URL) -> LibraryError {
    LibraryError(innerError: error, details: .updateMetadata(at: url))
  }

  static func fromDatabaseError(_ error: Error) -> LibraryError {
    LibraryError(innerError: error, details: .database)
  }

  static func copyFrom(_ importingURL: URL, to libraryURL: URL, withError error: Error) -> LibraryError {
    LibraryError(innerError: error, details: .copyImage(from: importingURL, to: libraryURL))
  }

  static func systemResolutionError(_ error: Error) throws -> LibraryError {
    try .init(innerError: error, as: VMSystemError.self, details: .systemResolution)
  }
}
