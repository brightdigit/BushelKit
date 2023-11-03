//
// IssueHandlerBuilder.swift
// Copyright (c) 2023 BrightDigit.
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

    public static func buildPartialBlock(
      first: AuditIssueFilter
    ) -> [AuditIssueFilterClosure] {
      buildPartialBlock(first: first.callAsFunction(_:))
    }

    public static func buildPartialBlock(
      accumulated: [AuditIssueFilterClosure],
      next: AuditIssueFilter
    ) -> [AuditIssueFilterClosure] {
      buildPartialBlock(accumulated: accumulated, next: next.callAsFunction(_:))
    }
  }
#endif
