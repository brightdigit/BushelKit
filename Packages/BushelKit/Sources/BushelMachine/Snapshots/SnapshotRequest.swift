//
// SnapshotRequest.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct SnapshotRequest {
  public init(name: String = "", notes: String = "") {
    self.name = name
    self.notes = notes
  }

  public let name: String
  public let notes: String
}