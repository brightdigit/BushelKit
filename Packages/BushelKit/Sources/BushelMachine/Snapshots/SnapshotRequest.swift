//
// SnapshotRequest.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct SnapshotRequest {
  public let name: String
  public let notes: String
  public init(name: String = "", notes: String = "") {
    self.name = name
    self.notes = notes
  }
}
