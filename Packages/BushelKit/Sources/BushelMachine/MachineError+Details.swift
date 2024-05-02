//
// MachineError+Details.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public extension MachineError {
  enum Details: Sendable {
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
    case snapshot
    case session

    // swiftlint:disable:next cyclomatic_complexity
    func errorDescription(fromError error: (any Error)?) -> String {
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
      case .snapshot:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return SnapshotError.description(from: error)

      case .session:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "Unable to contnue with session: \(error.localizedDescription)"
      }
    }

    func recoverySuggestion(fromError _: (any Error)?) -> String? {
      switch self {
      case .accessDeniedLibraryAt:
        "Close and open the library again."
      default:
        nil
      }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func isRecoverable(fromError _: (any Error)?) -> Bool {
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

      case .snapshot:
        false

      case .session:
        false
      }
    }
  }
}
