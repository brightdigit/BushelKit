//
// RestoreImageContext.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct RestoreImageContext: Codable, Hashable, Identifiable, UserDefaultsCodable {
  internal init(name: String, id: UUID, metadata: ImageMetadata, library: RestoreImageLibraryContext) {
    self.name = name
    self.id = id
    self.metadata = metadata
    self.library = library
  }

  public let name: String
  public let id: UUID
  public let metadata: ImageMetadata
  public let library: RestoreImageLibraryContext

  public init(library: RestoreImageLibraryContext, file: RestoreImageLibraryItemFile) {
    self.init(name: file.name, id: file.id, metadata: file.metadata, library: library)
  }

  public static var key: UserDefaultsKey {
    .images
  }
}
