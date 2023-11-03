//
// LibraryTests.swift
// Copyright (c) 2023 BrightDigit.
//

#if os(macOS)
  import BushelUITestingUtilities
  import XCTest

  open class LibraryTests: XCTestCase {
    public func testLibrary() throws {
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