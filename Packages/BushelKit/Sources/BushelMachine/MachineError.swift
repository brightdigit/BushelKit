//
// MachineError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct MachineError: LocalizedError, LoggerCategorized {
  public static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }

  public typealias LoggersType = BushelLogging.Loggers

  fileprivate init<TypedError: Error>(innerError: Error, as _: TypedError.Type, details: MachineError.Details) throws {
    guard let innerError = innerError as? TypedError else {
      throw innerError
    }
    self.init(innerError: innerError, details: details)
  }

  fileprivate init(innerError: Error? = nil, details: MachineError.Details) {
    if let innerError = innerError as? MachineError {
      assertionFailure("Creating RestoreLibraryError \(details) within RestoreLibraryError: \(innerError)")
      Self.logger.critical("Creating RestoreLibraryError \(details.errorDescription(fromError: innerError)) within RestoreLibraryError: \(innerError)")
    }
    self.innerError = innerError
    self.details = details
  }

  enum Details {
    private struct UnknownError: Error {
      private init() {}
      fileprivate static let shared = UnknownError()
    }

    case bookmarkError
    case systemResolution
    case missingRestoreImageWithID(InstallerImageIdentifier)
    case accessDeniedLibrary(at: URL)
    case corrupted(at: URL)
    case database

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

      case let .corrupted(at: libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue reading the library at \(libraryURL): \(error)"
      case .database:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There was an issue syncing with the database: \(error)"

      case let .missingRestoreImageWithID(id):
        return "There's an issue finding referenced restore image: \(id)"
      }
    }

    func recoverySuggestion(fromError _: Error?) -> String? {
      switch self {
      case .accessDeniedLibrary(at: _):
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

      case .corrupted(at: _):
        return false

      case .database:
        return false

      case .systemResolution:
        return false

      case .missingRestoreImageWithID:
        return true
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

public extension MachineError {
  static func bookmarkError(_ error: Error) throws -> MachineError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  static func accessDeniedError(_ error: Error?, at url: URL) -> MachineError {
    MachineError(innerError: error, details: .accessDeniedLibrary(at: url))
  }

  static func corruptedError(_ error: Error, at url: URL) -> MachineError {
    MachineError(innerError: error, details: .corrupted(at: url))
  }

  static func fromDatabaseError(_ error: Error) -> MachineError {
    MachineError(innerError: error, details: .database)
  }
}
