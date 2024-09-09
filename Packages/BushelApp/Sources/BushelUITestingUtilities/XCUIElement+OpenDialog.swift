//
// XCUIElement+OpenDialog.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  public import XCTest

  extension XCUIElement {
    public func openFile(atPath path: String) {
      let openButton = self.buttons["Open"]
      let whereButton = self.popUpButtons["Where:"]
      XCTAssert(whereButton.exists)
      XCTAssert(openButton.exists)
      self.typeKey("g", modifierFlags: [.command, .shift])
      let sheet = self.sheets.firstMatch
      XCTAssert(sheet.waitForExistence(timeout: 5))
      let input = sheet.textFields["PathTextField"]
      XCTAssert(input.exists)

      input.typeText(path)
      input.typeKey(.return, modifierFlags: [])
      XCTAssert(openButton.waitForExistence(timeout: 3.0))
      openButton.click()
    }
  }
#endif
