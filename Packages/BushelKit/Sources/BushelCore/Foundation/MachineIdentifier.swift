//
// MachineIdentifier.swift
// Copyright (c) 2024 BrightDigit.
//

public struct MachineIdentifier: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case ecID = "ECID"
  }

  public let ecID: UInt64
}
