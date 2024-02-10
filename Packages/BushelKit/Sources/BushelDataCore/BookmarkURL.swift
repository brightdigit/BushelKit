//
// BookmarkURL.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import Foundation

  public struct BookmarkURL {
    let data: BookmarkData
    public let url: URL
    let databaseError: (any Error) -> any Error

    internal init(data: BookmarkData, url: URL, databaseError: @escaping (any Error) -> any Error) {
      self.data = data
      self.url = url
      self.databaseError = databaseError
    }

    public func stopAccessing(updateTo database: any Database) async throws {
      do {
        try await data.update(using: database)
      } catch {
        assertionFailure(error: error)
      }

      do {
        try await database.save()
      } catch {
        throw self.databaseError(error)
      }

      url.stopAccessingSecurityScopedResource()
    }
  }
#endif
