//
// MachineStorageSpecification.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MachineStorageSpecification: Codable, Identifiable {
  public let id: UUID
  public var size: UInt64
  public var label: String
  public init(id: UUID = .init(), label: String, size: UInt64) {
    self.id = id
    self.label = label
    self.size = size
  }
}
