//
// DocumentTypeFilter.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct DocumentTypeFilter: OptionSet, Sendable {
  public typealias RawValue = Int
  public static let libraries: DocumentTypeFilter = .init(rawValue: 1)

  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}

public extension DocumentTypeFilter {
  var searchStrings: [String] {
    var pathExtensions = [String?]()
    if self.contains(.libraries) {
      pathExtensions.append(
        FileType.restoreImageLibrary.fileExtension
      )
    }
    return pathExtensions.compactMap { pathExtension in
      guard let pathExtension else {
        return nil
      }
      return ".\(pathExtension)"
    }
  }
}
