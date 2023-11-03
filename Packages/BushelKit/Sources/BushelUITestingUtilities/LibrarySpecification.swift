//
// LibrarySpecification.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct LibrarySpecification {
  let imageSourceDirectory: URL
  let libraryDestinationDirectoryPath: String
  let name: String
  let maximumDesiredLibraryImageCount: Int

  public init(
    imageSourceDirectory: URL,
    libraryDestinationDirectoryPath: String,
    name: String = UUID().uuidString,
    maximumDesiredLibraryImageCount: Int = 2
  ) {
    self.imageSourceDirectory = imageSourceDirectory
    self.libraryDestinationDirectoryPath = libraryDestinationDirectoryPath
    self.name = name
    self.maximumDesiredLibraryImageCount = maximumDesiredLibraryImageCount
  }
}
