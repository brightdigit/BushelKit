//
// XCUIElement+WelcomeView.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import XCTest

  extension XCUIElement {
    public func startNewLibrary(
      withName name: String,
      inDirectoryPath directoryPath: String,
      viewElementFromApp app: XCUIApplication
    ) -> XCUIElement {
      let pathWithoutExtension = [directoryPath, name].joined(separator: "/")
      XCTAssertEqual(self.identifier, "welcomeView")
      self.buttons["welcomeStartLibraryTitle"].click()
      let savePanel = app.windows["save-panel"]
      XCTAssert(savePanel.exists)
      savePanel.createNewFile(pathWithoutExtension)
      let name = URL(fileURLWithPath: pathWithoutExtension).lastPathComponent
      return app.windows.matching(NSPredicate(format: "title = %@", "\(name).bshrilib")).element
    }
  }

#endif
