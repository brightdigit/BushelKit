//
// URLInstallerImage.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLibrary
import BushelLogging
import BushelMachine
import Foundation

struct URLInstallerImage: InstallerImage, Loggable, Sendable {
  var libraryID: LibraryIdentifier? {
    .url(url)
  }

  let imageID: UUID

  let url: URL

  let metadata: Metadata
  init(imageID: UUID, url: URL, metadata: URLInstallerImage.Metadata) {
    self.imageID = imageID
    self.url = url
    self.metadata = metadata
  }

  init(imageID: UUID, url: URL, _ labelProvider: @escaping MetadataLabelProvider) throws {
    let library = try Library(contentsOf: url)

    guard let image = library.items.first(where: { $0.id == imageID }) else {
      let error = InstallerImageError(imageID: imageID, type: .imageNotFound, libraryID: .url(url))
      assertionFailure(error: error)
      Self.logger.error("Unable to find image: \(error)")
      throw error
    }

    let metadata: Metadata = .init(labelName: image.name, imageMetadata: image.metadata, labelProvider)

    self.init(imageID: imageID, url: url, metadata: metadata)
  }

  func getURL() throws -> URL {
    url
  }
}
