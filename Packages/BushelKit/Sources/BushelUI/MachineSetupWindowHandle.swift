//
// MachineSetupWindowHandle.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

struct MachineSetupWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  internal init(restoreImagePath: MachineSetupWindowHandle.RestoreImagePath? = nil) {
    self.restoreImagePath = restoreImagePath
  }

  struct RestoreImagePath: Equatable {
    internal init(restoreLibraryPath: String, imageID: UUID) {
      self.restoreLibraryPath = restoreLibraryPath
      self.imageID = imageID
    }

    let restoreLibraryPath: String
    let imageID: UUID

    var path: String {
      [restoreLibraryPath, imageID.description].joined(separator: "/")
    }

    internal init?(externalURL: URL) throws {
      if externalURL.path.isEmpty {
        return nil
      }
      let idString = externalURL.lastPathComponent
      let restoreLibraryURL = externalURL.deletingLastPathComponent()
      guard let imageID = UUID(uuidString: idString) else {
        throw DocumentError.undefinedType("invalid id", idString)
      }

      self.init(restoreLibraryPath: restoreLibraryURL.path, imageID: imageID)
    }
  }

  let restoreImagePath: RestoreImagePath?
  var path: String? {
    restoreImagePath?.path
  }

  static let host = "build"

  static func externalURL(fromActualURL actualURL: URL) throws -> RestoreImagePath {
    let idString = actualURL.deletingPathExtension().lastPathComponent
    let restoreImageURL = actualURL.deletingLastPathComponent()
    guard restoreImageURL.lastPathComponent == Paths.restoreImagesDirectoryName else {
      throw DocumentError.undefinedType("invalid url", actualURL)
    }
    guard let imageID = UUID(uuidString: idString) else {
      throw DocumentError.undefinedType("invalid id", idString)
    }
    let path = restoreImageURL.deletingLastPathComponent().path
    return .init(restoreLibraryPath: path, imageID: imageID)
  }
}
