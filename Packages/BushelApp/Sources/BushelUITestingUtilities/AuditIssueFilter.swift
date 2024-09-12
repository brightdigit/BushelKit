//
// AuditIssueFilter.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  public import XCTest

  public protocol AuditIssueFilter {
    @MainActor
    func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool
  }
#endif
