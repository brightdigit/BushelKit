//
// MachineStorageSpecification.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct MachineStorageSpecification: Codable, Identifiable {
  public init(id: UUID = .init(), size: UInt64) {
    self.id = id
    self.size = size
  }

  public let id: UUID
  public let size: UInt64
}
