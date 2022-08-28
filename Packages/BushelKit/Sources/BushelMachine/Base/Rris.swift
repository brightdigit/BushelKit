//
// Rris.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

public struct Rris: Identifiable, Hashable {
  public init(id: String, title: String, fetch: @escaping () async throws -> [RestoreImage]) {
    self.id = id
    self.title = title
    self.fetch = fetch
  }

  public static func == (lhs: Rris, rhs: Rris) -> Bool {
    lhs.id == rhs.id
  }

  public let id: String
  public let title: String
  public let fetch: () async throws -> [RestoreImage]

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
