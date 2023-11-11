//
// CloseButtonFilter.swift
// Copyright (c) 2023 BrightDigit.
//

#if os(macOS)
  import Foundation
  import XCTest

  public struct CloseButtonFilter: AuditIssueFilter {
    let closeButtonSize: CGSize

    public init(closeButtonSize: CGSize) {
      self.closeButtonSize = closeButtonSize
    }

    public func callAsFunction(_ issue: XCUIAccessibilityAuditIssue) -> Bool {
      issue.element?.elementType == .group &&
        issue.element?.frame.size == closeButtonSize &&
        issue.auditType == .parentChild &&
        issue.element?.isEnabled == false
    }
  }
#endif
