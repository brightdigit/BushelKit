//
// InstallerImageError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public struct InstallerImageError: Error {
  public init(imageID: UUID, libraryID: LibraryIdentifier? = nil, type: InstallerImageError.ErrorType) {
    self.imageID = imageID
    self.libraryID = libraryID
    self.type = type
  }

  public let imageID: UUID
  public let libraryID: LibraryIdentifier?
  public let type: ErrorType

  public enum ErrorType {
    case missingBookmark
    case accessDeniedURL(URL)
    case imageNotFound
  }
}
