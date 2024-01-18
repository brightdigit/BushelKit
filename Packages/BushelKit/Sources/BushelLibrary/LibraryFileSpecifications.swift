//
// LibraryFileSpecifications.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public enum LibraryFileSpecifications: InitializableFileTypeSpecification {
  public typealias WindowValueType = LibraryFile

  public static let fileType: FileType = .restoreImageLibrary

  public static func createAt(_ url: URL) throws -> LibraryFile {
    _ = try Library.createAt(url)
    return .init(url: url)
  }
}
