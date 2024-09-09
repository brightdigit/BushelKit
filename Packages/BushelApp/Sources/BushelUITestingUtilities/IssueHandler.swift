//
// IssueHandler.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  public import Foundation

  public import XCTest

  public struct IssueHandler {
    let filters: [AuditIssueFilterClosure]
    private init(filters: [AuditIssueFilterClosure]) {
      self.filters = filters
    }

    private init(_ filters: AuditIssueFilterClosure...) {
      self.init(filters: filters)
    }

    public init(@IssueHandlerBuilder _ body: () -> [AuditIssueFilterClosure]) {
      self.init(filters: body())
    }

    @MainActor
    public func handle(_ issue: XCUIAccessibilityAuditIssue) -> Bool {
      for filter in filters where filter(issue) {
        return true
      }
      return false
    }
  }

  extension IssueHandler {
    @MainActor
    public static func `default`(
      closeButtonSize: CGSize
    ) -> IssueHandler {
      .init {
        Filter { $0.element?.elementType == .touchBar }
        Filter { $0.auditType == .contrast }
        WelcomeViewIssueFilter()
        CloseButtonFilter(closeButtonSize: closeButtonSize)
      }
    }
  }
#endif
