//
// RestoreImagePath.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public struct RestoreImagePath: Equatable {
  public let restoreLibraryPath: String
  public let imageID: UUID

  public var path: String {
    [restoreLibraryPath, imageID.description].joined(separator: "/")
  }

  internal init(restoreLibraryPath: String, imageID: UUID) {
    self.restoreLibraryPath = restoreLibraryPath
    self.imageID = imageID
  }

  public init?(externalURL: URL) throws {
    if externalURL.path.isEmpty {
      return nil
    }
    let idString = externalURL.lastPathComponent
    let restoreLibraryURL = externalURL.deletingLastPathComponent()
    guard let imageID = UUID(uuidString: idString) else {
      throw MachineError.undefinedType("invalid id", idString)
    }

    self.init(restoreLibraryPath: restoreLibraryURL.path, imageID: imageID)
  }

  public init(actualURL: URL) throws {
    let idString = actualURL.deletingPathExtension().lastPathComponent
    let restoreImageURL = actualURL.deletingLastPathComponent()
    guard restoreImageURL.lastPathComponent == Paths.restoreImagesDirectoryName else {
      throw MachineError.undefinedType("invalid url", actualURL)
    }
    guard let imageID = UUID(uuidString: idString) else {
      throw MachineError.undefinedType("invalid id", idString)
    }
    let path = restoreImageURL.deletingLastPathComponent().path
    self.init(restoreLibraryPath: path, imageID: imageID)
  }
}
