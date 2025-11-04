//
//  LibraryError+Details.swift
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

public import Foundation

extension LibraryError {
  public enum Details: Sendable {
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

    private struct UnknownError: Error {
      fileprivate static let shared = UnknownError()

      private init() {}
    }

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
      case let .accessDeniedLibraryAt(at: path):
        let components: [String?] = [
          "There's an issue getting access to library at \(path)", error?.localizedDescription,
        ]
        return components.compactMap(\.self).joined(separator: ": ")
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

    internal func recoverySuggestion(fromError _: (any Error)?) -> String? {
      switch self {
      case .accessDeniedLibraryAt: "Close and open the library again."
      case let .imageCorruptedAt(at: imageURL): "Invalid Restore Image at \(imageURL)"
      case .imageFolderInitializationAt: "Close and open the library again."
      case .missingInitialization: "Close and open the library again."
      default: nil
      }
    }

    // swiftlint:disable:next cyclomatic_complexity
    internal func isRecoverable(fromError _: (any Error)?) -> Bool {
      switch self {
      case .bookmarkError: false

      case .accessDeniedLibraryAt: false

      case .imageCorruptedAt: true

      case .libraryCorruptedAt: false

      case .imageFolderInitializationAt: false

      case .updateMetadataAt: false

      case .missingInitialization: false

      case .database: false

      case .copyImage: true

      case .systemResolution: false
      }
    }
  }
}
