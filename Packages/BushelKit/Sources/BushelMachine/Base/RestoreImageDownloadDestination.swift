//
// RestoreImageDownloadDestination.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import Foundation

public enum RestoreImageDownloadDestination {
  case library
  case ipswFile
}

public extension RestoreImageDownloadDestination {
  func destinationURL(fromSavePanelURL url: URL) throws -> URL {
    guard self == .library else {
      return url
    }

    let libraryDirectoryExists = FileManager.default.directoryExists(at: url)
    guard libraryDirectoryExists != .fileExists else {
      throw MissingError.needDefinition("Invalid Library")
    }

    let restoreImagesSubdirectoryURL = url.appendingPathComponent("Restore Images")

    let restoreImageSubdirectoryExists = FileManager.default.directoryExists(at: restoreImagesSubdirectoryURL)

    guard restoreImageSubdirectoryExists != .fileExists else {
      throw MissingError.needDefinition("Invalid Library")
    }

    if restoreImageSubdirectoryExists == .notExists {
      try FileManager.default.createDirectory(at: restoreImagesSubdirectoryURL, withIntermediateDirectories: true)
    }

    return restoreImagesSubdirectoryURL.appendingPathComponent(url.lastPathComponent)
  }
}