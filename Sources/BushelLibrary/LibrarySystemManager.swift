//
//  LibrarySystemManager.swift
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
public import BushelLogging
public import Foundation
public import RadiantDocs

/// Manages the library systems and their associated file types.
public final class LibrarySystemManager: LibrarySystemManaging, Loggable, Sendable {
  /// A closure that determines the `FileType` for a given `URL`.
  public let fileTypeBasedOnURL: @Sendable (URL) -> FileType?

  private let fileTypeMap: [FileType: VMSystemID]
  private let implementations: [VMSystemID: any LibrarySystem]

  /// The list of all allowed file types across all the library systems.
  public var allAllowedFileTypes: [FileType] {
    self.implementations.values.flatMap(\.allowedContentTypes)
  }

  /// Initializes the `LibrarySystemManager` with the given library system implementations
  /// and a closure to determine the file type for a given URL.
  /// - Parameters:
  ///   - implementations: An array of `LibrarySystem` instances.
  ///   - fileTypeBasedOnURL: A closure that determines the `FileType` for a given `URL`.
  public init(
    _ implementations: [any LibrarySystem],
    fileTypeBasedOnURL: @escaping @Sendable (URL) -> FileType?
  ) {
    self.implementations = .init(
      uniqueKeysWithValues:
        implementations.map {
          ($0.id, $0)
        }
    )

    self.fileTypeMap = self.implementations.mapValues {
      $0.allowedContentTypes
    }
    .reduce(into: [FileType: VMSystemID]()) { partialResult, pair in
      for value in pair.value {
        partialResult[value] = pair.key
      }
    }

    Self.logger.debug("LibrarySystems Initialized: \(implementations.map(\.shortName))")
    Self.logger.debug(
      "LibrarySystems Supported FileTypes: \(self.fileTypeMap.keys.map(\.utIdentifier))"
    )

    self.fileTypeBasedOnURL = fileTypeBasedOnURL
  }

  /// Resolves the `VMSystemID` for the given URL.
  /// - Parameter url: The URL to resolve the system ID for.
  /// - Returns: The `VMSystemID` for the given URL, or `nil` if the file type is unknown.
  public func resolveSystemFor(url: URL) -> VMSystemID? {
    guard let type = self.fileTypeBasedOnURL(url) else {
      Self.logger.error("Unknown path extension: \(url.pathExtension)")
      return nil
    }

    return self.fileTypeMap[type]
  }

  /// Resolves the `LibrarySystem` instance for the given `VMSystemID`.
  /// - Parameter id: The `VMSystemID` of the library system to resolve.
  /// - Returns: The `LibrarySystem` instance for the given ID.
  public func resolve(_ id: VMSystemID) -> any LibrarySystem {
    guard let implementations = implementations[id] else {
      Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("")
    }

    return implementations
  }
}
