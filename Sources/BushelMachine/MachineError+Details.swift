//
//  MachineError+Details.swift
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
internal import BushelLogging
public import Foundation

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif

extension MachineError {
  /// A collection of detailed error cases related to a machine.
  public enum Details: Sendable {
    /// Represents an error related to a bookmark.
    case bookmarkError
    /// Represents an error related to system resolution.
    case systemResolution
    /// Represents an error related to a missing restore image with a specific identifier.
    case missingRestoreImageWithID(InstallerImageIdentifier)
    /// Represents an error related to denied access to a library at a specific URL.
    case accessDeniedLibraryAt(URL)
    /// Represents an error related to a corrupted library at a specific URL.
    case corruptedAt(URL)
    /// Represents an error related to the database.
    case database
    /// Represents an error related to a missing object property.
    case missingProperty(ObjectProperty)
    /// Represents an error related to a snapshot.
    case snapshot
    /// Represents an error related to a session.
    case session
    /// Represents an error related to a not found bookmark ID.
    case notFoundBookmarkID(UUID)
    /// Represents an error related to a capture.
    case captureError
    /// Represents an error related to a capture update.
    case captureUpdateError(UUID)
    /// Represents an error related to exporting screenshots at a specific URL.
    case exportScreenshotsErrorAt(URL)
    /// Represents an error related to a missing image with a specific identifier.
    case missingImage(UUID)
    /// Represents an error related to a missing video with a specific identifier.
    case missingVideo(UUID)

    private struct UnknownError: Error {
      fileprivate static let shared = UnknownError()

      private init() {}
    }

    // swiftlint:disable cyclomatic_complexity function_body_length

    /// Returns an error description based on the specific error case and the provided error, if any.
    ///
    /// - Parameter error: An optional error that occurred.
    /// - Returns: A string describing the error.
    internal func errorDescription(fromError error: (any Error)?) -> String {
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
          "There's an issue getting access to library at \(path)", error?.localizedDescription,
        ]
        return components.compactMap(\.self).joined(separator: ": ")

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

      case .captureError:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "Unable to capture screen: \(error.localizedDescription)"

      case let .captureUpdateError(id):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "Unable to update capture item \(id): \(error.localizedDescription)"

      case .exportScreenshotsErrorAt:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "Unable to export screenshots: \(error.localizedDescription)"

      case let .notFoundBookmarkID(id):
        return "There's an issue finding machine with bookmark ID: \(id)"

      case let .missingImage(id):
        return "Unable to delete image \(id)"

      case let .missingVideo(id):
        return "Unable to delete video \(id)"
      }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length

    /// Returns a recovery suggestion for the specific error case, if any.
    ///
    /// - Parameter error: An optional error that occurred.
    /// - Returns: A string describing the recovery suggestion, or `nil` if no suggestion is available.
    internal func recoverySuggestion(fromError _: (any Error)?) -> String? {
      switch self {
      case .accessDeniedLibraryAt:
        "Close and open the library again."
      default:
        nil
      }
    }

    // swiftlint:disable cyclomatic_complexity
    /// Determines whether the specific error case is recoverable based on the provided error, if any.
    ///
    /// - Parameter error: An optional error that occurred.
    /// - Returns: `true` if the error is recoverable, `false` otherwise.
    internal func isRecoverable(fromError _: (any Error)?) -> Bool {
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

      case .notFoundBookmarkID:
        false

      case .captureError:
        false

      case .captureUpdateError:
        false

      case .exportScreenshotsErrorAt:
        false

      case .missingImage:
        false

      case .missingVideo:
        false
      }
    }
    // swiftlint:enable cyclomatic_complexity
  }
}
