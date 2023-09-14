//
// LibraryImageEntry.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelLibraryData
  import Foundation

  extension LibraryImageEntry {
    var libraryBookmarkIDString: String {
      assert(self.library != nil)
      return self.library?.bookmarkDataID.uuidString ?? ""
    }
  }
#endif
