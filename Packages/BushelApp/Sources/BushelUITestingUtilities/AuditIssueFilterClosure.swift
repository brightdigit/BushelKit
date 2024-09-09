//
// AuditIssueFilterClosure.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  public import XCTest

  public typealias AuditIssueFilterClosure = @Sendable @MainActor (XCUIAccessibilityAuditIssue) -> Bool
#endif
