//
// InstallerImageError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public struct InstallerImageError: Error, Sendable {
  public enum ErrorType: Sendable {
    case missingBookmark
    case accessDeniedURL(URL)
    case imageNotFound
  }

  public let imageID: UUID
  public let libraryID: LibraryIdentifier?
  public let type: ErrorType

  public init(imageID: UUID, type: InstallerImageError.ErrorType, libraryID: LibraryIdentifier? = nil) {
    self.imageID = imageID
    self.libraryID = libraryID
    self.type = type
  }
}
