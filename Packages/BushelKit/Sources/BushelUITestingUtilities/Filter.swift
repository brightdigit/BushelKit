//
// Filter.swift
// Copyright (c) 2023 BrightDigit.
//

#if os(macOS)
  import Foundation
  import XCTest
  public struct Filter: AuditIssueFilter {
    let closure: AuditIssueFilterClosure

    init(_ closure: @escaping AuditIssueFilterClosure) {
      self.closure = closure
    }

    public func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool {
      closure(issue)
    }
  }
#endif
