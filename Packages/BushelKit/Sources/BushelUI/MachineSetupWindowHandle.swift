//
// MachineSetupWindowHandle.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation
struct MachineSetupWindowHandle: StaticConditionalHandle, HostOnlyConditionalHandle {
  struct RestoreImagePath {
    let restoreLibraryPath: String
    let imageID: UUID

    var path: String {
      [restoreLibraryPath, imageID.description].joined(separator: "/")
    }
  }

  let restoreImagePath: RestoreImagePath?
  var path: String? {
    restoreImagePath?.path
  }

  static let host = "build"

  static func actualURL(fromExternalURL externalURL: URL) throws -> URL {
    let idString = externalURL.lastPathComponent
    let restoreLibraryURL = externalURL.deletingLastPathComponent()
    guard let id = UUID(uuidString: idString) else {
      throw DocumentError.undefinedType("invalid id", idString)
    }

    let actualURL = restoreLibraryURL
      .appendingPathComponent("Restore Images", isDirectory: true)
      .appendingPathComponent(id.uuidString)
      .appendingPathExtension("ipsw")
    return .init(fileURLWithPath: actualURL.path)
  }

  static func externalURL(fromActualURL actualURL: URL) throws -> RestoreImagePath {
    let idString = actualURL.deletingPathExtension().lastPathComponent
    let restoreImageURL = actualURL.deletingLastPathComponent()
    guard restoreImageURL.lastPathComponent == "Restore Images" else {
      throw DocumentError.undefinedType("invalid url", actualURL)
    }
    guard let imageID = UUID(uuidString: idString) else {
      throw DocumentError.undefinedType("invalid id", idString)
    }
    let path = restoreImageURL.deletingLastPathComponent().path
    return .init(restoreLibraryPath: path, imageID: imageID)
  }
}
