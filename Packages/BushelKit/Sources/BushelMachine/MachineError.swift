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
  public typealias LoggersType = BushelLogging.Loggers

  public enum ObjectProperty {
    case url
    case machine
    case snapshot
  }

  enum Details {
    private struct UnknownError: Error {
      private init() {}
      // swiftlint:disable:next strict_fileprivate
      fileprivate static let shared = UnknownError()
    }

    case bookmarkError
    case systemResolution
    case missingRestoreImageWithID(InstallerImageIdentifier)
    case accessDeniedLibraryAt(URL)
    case corruptedAt(URL)
    case database
    case missingProperty(ObjectProperty)

    // swiftlint:disable:next cyclomatic_complexity
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

      case let .accessDeniedLibraryAt(path):
        let components: [String?] = [
          "There's an issue getting access to library at \(path)", error?.localizedDescription
        ]
        return components.compactMap { $0 }.joined(separator: ": ")

      case let .corruptedAt(libraryURL):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There's an issue reading the library at \(libraryURL): \(error)"
      case .database:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "There was an issue syncing with the database: \(error)"

      case let .missingRestoreImageWithID(id):
        return "There's an issue finding referenced restore image: \(id)"

      case let .missingProperty(property):
        return "Missing object property: \(property)"
      }
    }

    func recoverySuggestion(fromError _: Error?) -> String? {
      switch self {
      case .accessDeniedLibraryAt:
        "Close and open the library again."
      default:
        nil
      }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func isRecoverable(fromError _: Error?) -> Bool {
      switch self {
      case .bookmarkError:
        false

      case .accessDeniedLibraryAt:
        false

      case .corruptedAt:
        false

      case .database:
        false

      case .systemResolution:
        false

      case .missingRestoreImageWithID:
        true

      case .missingProperty:
        false
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

  private init<TypedError: Error>(
    innerError: Error,
    as _: TypedError.Type,
    details: MachineError.Details
  ) throws {
    guard let innerError = innerError as? TypedError else {
      throw innerError
    }
    self.init(details: details, innerError: innerError)
  }

  private init(details: MachineError.Details, innerError: Error? = nil) {
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
  static func missingProperty(_ property: ObjectProperty) -> MachineError {
    .init(details: .missingProperty(property))
  }

  static func bookmarkError(_ error: BookmarkError) -> MachineError {
    .init(details: .bookmarkError, innerError: error)
  }

  static func bookmarkError(_ error: Error) throws -> MachineError {
    try .init(innerError: error, as: BookmarkError.self, details: .bookmarkError)
  }

  static func accessDeniedError(_ error: Error?, at url: URL) -> MachineError {
    MachineError(details: .accessDeniedLibraryAt(url), innerError: error)
  }

  static func corruptedError(_ error: Error, at url: URL) -> MachineError {
    MachineError(details: .corruptedAt(url), innerError: error)
  }

  static func fromDatabaseError(_ error: Error) -> MachineError {
    MachineError(details: .database, innerError: error)
  }
}
