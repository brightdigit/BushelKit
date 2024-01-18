//
// URL.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension URL {
  init(_ staticString: StaticString) {
    guard let url = URL(string: .init(describing: staticString)) else {
      fatalError("Invalid URL String")
    }
    self = url
  }

  #if !os(Linux)
    init(resolvingSecurityScopeBookmarkData data: Data, bookmarkDataIsStale: inout Bool) throws {
      #if os(macOS)
        try self.init(
          resolvingBookmarkData: data,
          options: [.withSecurityScope],
          bookmarkDataIsStale: &bookmarkDataIsStale
        )
      #else
        try self.init(resolvingBookmarkData: data, bookmarkDataIsStale: &bookmarkDataIsStale)
      #endif
    }

    func bookmarkDataWithSecurityScope() throws -> Data {
      #if os(macOS)
        return try bookmarkData(options: .withSecurityScope)
      #else
        return try self.bookmarkData()
      #endif
    }
  #endif
}
