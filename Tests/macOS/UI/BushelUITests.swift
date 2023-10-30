//
//  BushelUITests.swift
//  BushelUITests
//
//  Created by Leo Dion on 9/1/22.
//

import XCTest

extension XCUIElement {
  fileprivate func createNewFile(_ pathWithoutExtension: String) {
    let savePanelTextField = self.textFields["saveAsNameTextField"]
    XCTAssert(savePanelTextField.exists)
    savePanelTextField.typeKey(.delete, modifierFlags: [])
    savePanelTextField.doubleClick()
    savePanelTextField.typeText(pathWithoutExtension)
    savePanelTextField.typeKey(.return, modifierFlags: [])
    self.typeKey(.return, modifierFlags: [])
  }
}
  
  extension XCUIElement {
  fileprivate func startNewLibrary(_ pathWithoutExtension: String, viewElementFromApp app: XCUIApplication) -> XCUIElement {
    XCTAssertEqual(self.identifier, "welcomeView")
    self.buttons["welcomeStartLibraryTitle"].click()
    
    let savePanel = app.windows["save-panel"]
    XCTAssert(savePanel.exists)
    
    savePanel.createNewFile(pathWithoutExtension)
    //createNewFile("~/Desktop/" + name, usingSavePanel: savePanel)
    let name = URL(fileURLWithPath: pathWithoutExtension).lastPathComponent
    //let identifier = "library:\(name).bshrilib:toolbar:plus"
    return app.windows.matching(NSPredicate(format: "title = %@", "\(name).bshrilib")).element
  }
  
}

typealias AuditIssueFilterClosure = (XCUIAccessibilityAuditIssue) -> Bool

protocol AuditIssueFilter {
  func callAsFunction (_ issue: XCUIAccessibilityAuditIssue) -> Bool
}

struct WelcomeViewIssueFilter : AuditIssueFilter {
  func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool {
    issue.auditType == .sufficientElementDescription &&
    //issue.element?.groups["welcomeView"].exists == true &&
    issue.element?.elementType == .group
  }
}

struct CloseButtonFilter : AuditIssueFilter {
  let closeButtonSize : CGSize
  
  func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool {
    issue.element?.elementType == .group &&
    issue.element?.frame.size == closeButtonSize &&
    issue.auditType == .parentChild &&
    issue.element?.isEnabled == false
  }
}

struct IssueHandler {
  internal init(filters: [AuditIssueFilterClosure]) {
    self.filters = filters
  }
  
  internal init(_ filters: AuditIssueFilterClosure...) {
    self.init(filters: filters)
  }
  
  let filters : [AuditIssueFilterClosure]
  
  func handle (_ issue: XCUIAccessibilityAuditIssue) -> Bool {
    for filter in filters {
      if filter(issue) {
        return true
      }
    }
    debugPrint(issue.element!)
    return false
  }
}
final class BushelUITests: XCTestCase {
  
  func testLibrary() throws {
    
    let app = XCUIApplication()
#warning("bring library in somehow")
    app.launchEnvironment = .init(uniqueKeysWithValues: [
      "SKIP_ONBOARDING",
      "RESET_APPLICATION",
      "ALLOW_DATABASE_REBUILD"
    ].map{
      ($0, true.description)
    })
    
    app.launch()
  
    let name = UUID().uuidString
    let welcomeView = app.groups["welcomeView"]
    XCTAssert(welcomeView.exists)
    let libraryView = welcomeView.startNewLibrary("~/Desktop/" + name, viewElementFromApp: app) //libraryView(welcomeView, app,
    XCTAssert(libraryView.exists)
    let plusButton =  libraryView.descendants(matching: .menuButton).matching(identifier: "library:\(name).bshrilib:toolbar:plus").element
    XCTAssert(plusButton.exists)
    plusButton.click()
   
    for imagefilePath in ProcessInfo.processInfo.arguments {
      print(imagefilePath)
    }
  }
  
  
  func testAccessibilityAudit() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launchEnvironment = .init(uniqueKeysWithValues: [
      "SKIP_ONBOARDING",
      "RESET_APPLICATION",
      "ALLOW_DATABASE_REBUILD"
    ].map{
      ($0, true.description)
    })
    app.launch()
    
    let closeButtonSize = app.buttons[XCUIIdentifierCloseWindow].frame.size
    let name = UUID().uuidString
    let welcomeView = app.groups["welcomeView"]
    XCTAssert(welcomeView.exists)
    let libraryView = welcomeView.startNewLibrary("~/Desktop/" + name, viewElementFromApp: app) //libraryView(welcomeView, app, &libraryView)
    XCTAssert(libraryView.exists)
    
    let issueHandler = IssueHandler(
      {$0.element?.elementType == .touchBar},
      {$0.auditType == .contrast},
      WelcomeViewIssueFilter().callAsFunction(_:),
      CloseButtonFilter(closeButtonSize: closeButtonSize).callAsFunction(_:)
    )
    
    try app.performAccessibilityAudit(issueHandler.handle)
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
