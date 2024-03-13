//
// LibraryTests.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelUITestingUtilities
  import XCTest

  open class LibraryTests: XCTestCase {
    @MainActor public func testLibrary() throws {
      let app: XCUIApplication = .launchBushel(withFlags: .resetApplication)
      try app.runLibraryCreation(
        specifications: .init(
          imageSourceDirectory: .init(fileURLWithPath: "/Volumes/Stuff/Images"),
          libraryDestinationDirectoryPath: "~/Desktop/",
          maximumDesiredLibraryImageCount: 6
        )
      )
    }
  }
#endif
