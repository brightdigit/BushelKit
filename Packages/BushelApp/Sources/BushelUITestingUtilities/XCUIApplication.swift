//
// XCUIApplication.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelCore
  import BushelMacOSCore
  import XCTest

  public extension XCUIApplication {
    static func launchBushel(withFlags flags: LaunchOptions) -> XCUIApplication {
      let app = XCUIApplication()

      if flags.contains(.resetApplication) {
        app.launchEnvironment = .init(uniqueKeysWithValues: [
          "SKIP_ONBOARDING",
          "RESET_APPLICATION",
          "ALLOW_DATABASE_REBUILD"
        ].map {
          ($0, true.description)
        })
      }

      app.launch()

      return app
    }

    @discardableResult
    func runLibraryCreation(specifications: LibrarySpecification) throws -> XCUIElement {
      let contents = try FileManager.default.contentsOfDirectory(
        at: specifications.imageSourceDirectory,
        includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey]
      )
      .filter { url in
        url.pathExtension == MacOSVirtualization.ipswFileExtension
      }
      .shuffled()
      .prefix(specifications.maximumDesiredLibraryImageCount)

      let welcomeView = self.groups["welcomeView"]
      XCTAssert(welcomeView.exists)
      let libraryView = welcomeView.startNewLibrary(
        withName: specifications.name,
        inDirectoryPath: specifications.libraryDestinationDirectoryPath,
        viewElementFromApp: self
      )
      XCTAssert(libraryView.exists)

      for ipswURL in contents {
        try libraryView.importImage(ipswURL)
      }
      return libraryView
    }
  }
#endif
