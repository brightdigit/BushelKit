//
// WelcomeViewIssueFilter.swift
// Copyright (c) 2023 BrightDigit.
//

#if os(macOS)
  import XCTest

  public struct WelcomeViewIssueFilter: AuditIssueFilter {
    public init() {}
    public func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool {
      issue.auditType == .sufficientElementDescription &&
        // issue.element?.groups["welcomeView"].exists == true &&
        issue.element?.elementType == .group
    }
  }
#endif
