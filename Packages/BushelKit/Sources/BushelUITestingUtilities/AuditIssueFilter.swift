//
// AuditIssueFilter.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import XCTest

  public protocol AuditIssueFilter {
    func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool
  }
#endif
