//
// Snapshot.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct Snapshot: Codable {
  internal init(id: UUID, createdAt: Date, fileLength: Int) {
    self.id = id
    self.createdAt = createdAt
    self.fileLength = fileLength
  }

  public let id: UUID
  public let createdAt: Date
  public let fileLength: Int
}
