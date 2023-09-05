//
// LibraryIdentifier.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum LibraryIdentifier: CustomStringConvertible, Hashable {
  public var description: String {
    switch self {
    case let .bookmarkID(id):
      return id.uuidString

    case let .url(url):
      return url.path
    }
  }

  case url(URL)
  case bookmarkID(UUID)

  public init(string: String) {
    if let id = UUID(uuidString: string) {
      self = .bookmarkID(id)
    } else {
      self = .url(.init(fileURLWithPath: string))
    }
  }
}
