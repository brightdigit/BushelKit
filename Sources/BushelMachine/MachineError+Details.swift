//
//  MachineError+Details.swift
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

public import BushelFoundation
import BushelLogging
public import Foundation

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif

extension MachineError {
  public enum Details: Sendable {
    private struct UnknownError: Error {
      private init() {}

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
    case notFoundBookmarkID(UUID)
    case captureError
    case captureUpdateError(UUID)

    // swiftlint:disable:next cyclomatic_complexity
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

      case .captureError:
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "Unable to capture screen: \(error.localizedDescription)"

      case .captureUpdateError(let id):
        assert(error != nil)
        let error = error ?? UnknownError.shared
        return "Unable to update capture item \(id): \(error.localizedDescription)"

      case let .notFoundBookmarkID(id):
        return "There's an issue finding machine with bookmark ID: \(id)"
      }
    }

    internal func recoverySuggestion(fromError _: (any Error)?) -> String? {
      switch self {
      case .accessDeniedLibraryAt:
        "Close and open the library again."
      default:
        nil
      }
    }

    // swiftlint:disable:next cyclomatic_complexity
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
      }
    }
  }
}
