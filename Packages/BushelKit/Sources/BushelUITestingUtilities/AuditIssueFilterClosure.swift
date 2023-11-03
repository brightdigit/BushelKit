//
// AuditIssueFilterClosure.swift
// Copyright (c) 2023 BrightDigit.
//

#if os(macOS)
  import XCTest

  public typealias AuditIssueFilterClosure = (XCUIAccessibilityAuditIssue) -> Bool
#endif
