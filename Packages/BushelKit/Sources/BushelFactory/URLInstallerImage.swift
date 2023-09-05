//
// URLInstallerImage.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLibrary
import BushelLogging
import BushelMachine
import Foundation

struct URLInstallerImage: InstallerImage, LoggerCategorized {
  public init(imageID: UUID, url: URL, metadata: URLInstallerImage.Metadata) {
    self.imageID = imageID
    self.url = url
    self.metadata = metadata
  }

  public init(imageID: UUID, url: URL, _ labelProvider: @escaping (VMSystemID, ImageMetadata) -> MetadataLabel) throws {
    let library = try Library(contentsOf: url)

    guard let image = library.items.first(where: { $0.id == imageID }) else {
      let error = InstallerImageError(imageID: imageID, libraryID: .url(url), type: .imageNotFound)
      assertionFailure(error: error)
      Self.logger.error("Unable to find image: \(error)")
      throw error
    }

    let metadata: Metadata = .init(labelName: image.name, imageMetadata: image.metadata, labelProvider)

    self.init(imageID: imageID, url: url, metadata: metadata)
  }

  var libraryID: LibraryIdentifier? {
    .url(url)
  }

  let imageID: UUID

  let url: URL

  let metadata: Metadata

  func getURL() throws -> URL {
    url
  }
}
