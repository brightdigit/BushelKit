//
// RestoreImageDownloadDestination.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum RestoreImageDownloadDestination {
  case library
  case ipswFile
}

//
// public extension RestoreImageDownloadDestination {
//  @available(*, deprecated)
//  func destinationURL(fromSavePanelURL url: URL) throws -> URL {
//    guard self == .library else {
//      return url
//    }
//
//    let libraryDirectoryExists = FileManager.default.directoryExists(at: url)
//    guard libraryDirectoryExists != .fileExists else {
//      throw MissingError.needDefinition("Invalid Library")
//    }
//
//    let restoreImagesSubdirectoryURL = url.appendingPathComponent(Paths.restoreImagesDirectoryName)
//
//    let restoreImageSubdirectoryExists = FileManager.default.directoryExists(
//      at: restoreImagesSubdirectoryURL
//    )
//
//    guard restoreImageSubdirectoryExists != .fileExists else {
//      throw MissingError.needDefinition("Invalid Library")
//    }
//
//    if restoreImageSubdirectoryExists == .notExists {
//      try FileManager.default.createDirectory(
//        at: restoreImagesSubdirectoryURL,
//        withIntermediateDirectories: true
//      )
//    }
//
//    return restoreImagesSubdirectoryURL.appendingPathComponent(url.lastPathComponent)
//  }
// }
