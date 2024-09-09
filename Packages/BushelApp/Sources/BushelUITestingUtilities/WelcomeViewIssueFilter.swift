//
// WelcomeViewIssueFilter.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  public import XCTest

  public struct WelcomeViewIssueFilter: AuditIssueFilter {
    public init() {}
    @MainActor
    public func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool {
      issue.auditType == .sufficientElementDescription &&
        // issue.element?.groups["welcomeView"].exists == true &&
        issue.element?.elementType == .group
    }
  }
#endif
