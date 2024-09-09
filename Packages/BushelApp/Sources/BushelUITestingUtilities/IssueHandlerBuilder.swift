//
// IssueHandlerBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import Foundation

  @resultBuilder
  public enum IssueHandlerBuilder {
    public static func buildPartialBlock(
      first: @escaping AuditIssueFilterClosure
    ) -> [AuditIssueFilterClosure] {
      [first]
    }

    public static func buildPartialBlock(
      accumulated: [AuditIssueFilterClosure],
      next: @escaping AuditIssueFilterClosure
    ) -> [AuditIssueFilterClosure] {
      accumulated + [next]
    }

    @MainActor
    public static func buildPartialBlock(
      first: any AuditIssueFilter
    ) -> [AuditIssueFilterClosure] {
      buildPartialBlock { issue in
        first.callAsFunction(issue)
      }
    }

    @MainActor
    public static func buildPartialBlock(
      accumulated: [AuditIssueFilterClosure],
      next: any AuditIssueFilter
    ) -> [AuditIssueFilterClosure] {
      buildPartialBlock(accumulated: accumulated) { issue in
        next.callAsFunction(issue)
      }
    }
  }
#endif
