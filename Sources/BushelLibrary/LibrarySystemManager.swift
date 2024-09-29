//
//  LibrarySystemManager.swift
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

public import BushelCore
public import BushelLogging
public import Foundation
public import RadiantDocs

public final class LibrarySystemManager: LibrarySystemManaging, Loggable, Sendable {
  public let fileTypeBasedOnURL: @Sendable (URL) -> FileType?

  private let fileTypeMap: [FileType: VMSystemID]
  private let implementations: [VMSystemID: any LibrarySystem]

  public var allAllowedFileTypes: [FileType] {
    implementations.values.flatMap(\.allowedContentTypes)
  }

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

    fileTypeMap = self.implementations.mapValues {
      $0.allowedContentTypes
    }
    .reduce(into: [FileType: VMSystemID]()) { partialResult, pair in
      for value in pair.value {
        partialResult[value] = pair.key
      }
    }

    Self.logger.debug("LibrarySystems Initialized: \(implementations.map(\.shortName))")
    Self.logger.debug(
      "LibrarySystems Supported FileTypes: \(self.fileTypeMap.keys.map(\.utIdentifier))")

    self.fileTypeBasedOnURL = fileTypeBasedOnURL
  }

  public func resolveSystemFor(url: URL) -> VMSystemID? {
    guard let type = self.fileTypeBasedOnURL(url) else {
      Self.logger.error("Unknown path extension: \(url.pathExtension)")
      return nil
    }

    return fileTypeMap[type]
  }

  public func resolve(_ id: VMSystemID) -> any LibrarySystem {
    guard let implementations = implementations[id] else {
      Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("")
    }

    return implementations
  }
}
