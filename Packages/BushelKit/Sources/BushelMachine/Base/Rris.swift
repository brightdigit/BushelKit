//
// Rris.swift
// Copyright (c) 2023 BrightDigit.
//

public struct Rris: Identifiable, Hashable {
  public init(
    id: String,
    title: String,
    fetch: @escaping () async throws -> [RestoreImage]
  ) {
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
