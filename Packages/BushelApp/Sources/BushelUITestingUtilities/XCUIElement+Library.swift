//
// XCUIElement+Library.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelCore

  public import Foundation

  public import XCTest

  extension XCUIElement {
    private func openImportDialog() -> XCUIElement {
      let plusButton = self.descendants(matching: .menuButton)
        .matching(identifier: "library:\(self.title):toolbar:plus")
        .element
      XCTAssert(plusButton.exists)
      plusButton.click()

      let importButton = self.descendants(matching: .menuItem)
        .matching(identifier: "library:\(self.title):toolbar:plus:import")
        .element
      XCTAssert(importButton.exists)
      importButton.click()

      let openSheet = self.sheets
        .matching(identifier: "open-panel")
        .element

      XCTAssert(openSheet.waitForExistence(timeout: 3.0))

      return openSheet
    }

    public func createLibraryImage(byImporting ipswURL: URL) -> XCUIElement {
      let ipswPath = ipswURL.path
      let imageList = self.outlines["library:\(self.title):list"]
      let osMetadata = OperatingSystemMetadata(basedOnURL: ipswURL)
      XCTAssert(imageList.exists)
      let initialChildCount = imageList.outlineRows.count
      let openSheet = openImportDialog()

      openSheet.openFile(atPath: ipswPath)

      let importProgress = XCUIApplication().descendants(matching: .progressIndicator)["progress-view"]
      XCTAssert(importProgress.waitForExistence(timeout: 15.0))
      let progressTitle = XCUIApplication().staticTexts["progress-title"]
      XCTAssert(progressTitle.exists)
      XCTAssertEqual(progressTitle.value as? String, osMetadata.operatingSystemLongName)
      let newChild = imageList.outlineRows.element(boundBy: initialChildCount).cells.firstMatch

      XCTAssert(newChild.waitForExistence(timeout: 10 * 60.0))
      return newChild
    }

    private func assertSelectedItem(matchesURL ipswURL: URL) throws {
      let osMetadata = OperatingSystemMetadata(basedOnURL: ipswURL)
      let selectedItem = self.groups["library:\(self.title):selected"]
      XCTAssert(selectedItem.waitForExistence(timeout: 3.0))
      let nameField = selectedItem.textFields["name-field"]
      XCTAssert(nameField.exists)
      XCTAssertEqual(
        nameField.value as? String,
        osMetadata.operatingSystemShorterName
      )
      let titleStaticText = selectedItem.staticTexts["operating-system-name"]
      XCTAssert(titleStaticText.exists)
      XCTAssertEqual(titleStaticText.value as? String, osMetadata.operatingSystemLongName)

      let attributes = try ipswURL.resourceValues(
        forKeys: [.fileSizeKey, .contentModificationDateKey]
      )
      let fileSize = attributes.fileSize.map(Int64.init)
      let lastModified = attributes.contentModificationDate

      let lastModifiedStatic = selectedItem.staticTexts["last-modified"]
      let contentLengthStatic = selectedItem.staticTexts["content-length"]

      XCTAssert(lastModifiedStatic.exists)
      XCTAssertEqual(
        lastModifiedStatic.value as? String,
        lastModified.map(Formatters.longDate.string(from:))
      )
      XCTAssert(contentLengthStatic.exists)
      XCTAssertEqual(
        contentLengthStatic.value as? String,
        fileSize.map(ByteCountFormatter.file.string(fromByteCount:))
      )
    }

    public func importImage(_ ipswURL: URL) throws {
      let newChild = self.createLibraryImage(byImporting: ipswURL)
      newChild.click()
      XCTAssert(newChild.isSelected)
      try self.assertSelectedItem(matchesURL: ipswURL)
    }
  }
#endif
