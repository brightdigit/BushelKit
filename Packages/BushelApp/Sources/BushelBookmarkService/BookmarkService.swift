//
// BookmarkService.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelDataCore
  import BushelDataMonitor
  import Foundation

  public struct BookmarkService: AgentRegister {
    public typealias AgentType = BookmarkServiceAgent

    let database: any Database
    public init(database: any Database) {
      self.database = database
    }

    public func agent() async -> BookmarkServiceAgent {
      .init(database: database)
    }
  }
#endif
