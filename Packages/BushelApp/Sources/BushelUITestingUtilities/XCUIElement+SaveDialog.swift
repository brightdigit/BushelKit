//
// XCUIElement+SaveDialog.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  public import XCTest

  extension XCUIElement {
    public func createNewFile(_ pathWithoutExtension: String) {
      let savePanelTextField = self.textFields["saveAsNameTextField"]
      XCTAssert(savePanelTextField.exists)
      savePanelTextField.typeKey(.delete, modifierFlags: [])
      savePanelTextField.doubleClick()
      savePanelTextField.typeText(pathWithoutExtension)
      savePanelTextField.typeKey(.return, modifierFlags: [])
      self.typeKey(.return, modifierFlags: [])
    }
  }
#endif
