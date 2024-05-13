//
// Library.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum Library {
  case libraryList(String)
  case selectedLibrary(String)
  case libraryImageItem(String, String)
  case libraryToolbarAction(String, String)
  case libraryToolbar(String)
  case nameField
  case operatingSystemName
  case contentLength
  case lastModified

  public var identifier: String {
    switch self {
    case let .libraryList(title):
      "library:" + title + ":list"
    case let .selectedLibrary(title):
      "library:" + title + ":selected"
    case let .libraryImageItem(title, id):
      "library:" + title + ":images:" + id

    case let .libraryToolbarAction(title, action):
      "library:" + title + ":toolbar:plus:\(action)"
    case let .libraryToolbar(title):
      "library:" + title + ":toolbar:plus"
    case .nameField:
      "name-field"
    case .operatingSystemName:
      "content-length"
    case .contentLength:
      "content-length"
    case .lastModified:
      "last-modified"
    }
  }
}
