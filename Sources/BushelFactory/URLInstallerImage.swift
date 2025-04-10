//
//  URLInstallerImage.swift
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
internal import BushelLibrary
public import BushelLogging
public import BushelMachine
public import Foundation

public struct URLInstallerImage: InstallerImage, Loggable, Sendable {
  public var libraryID: LibraryIdentifier? {
    .url(url)
  }

  public let imageID: UUID

  private let url: URL

  public let metadata: Metadata

  private init(imageID: UUID, url: URL, metadata: URLInstallerImage.Metadata) {
    self.imageID = imageID
    self.url = url
    self.metadata = metadata
  }

  public init(imageID: UUID, url: URL, _ labelProvider: @escaping MetadataLabelProvider) throws {
    let library = try Library(contentsOf: url)

    guard let image = library.items.first(where: { $0.id == imageID }) else {
      let error = InstallerImageError(imageID: imageID, type: .imageNotFound, libraryID: .url(url))
      assertionFailure(error: error)
      Self.logger.error("Unable to find image: \(error)")
      throw error
    }

    let metadata: Metadata = .init(
      labelName: image.name,
      imageMetadata: image.metadata,
      labelProvider
    )

    self.init(imageID: imageID, url: url, metadata: metadata)
  }

  public func getURL() throws -> URL {
    url
  }
}
