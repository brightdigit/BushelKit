//
// MachineIdentifier.swift
// Copyright (c) 2024 BrightDigit.
//

/// A struct representing a unique identifier for a machine.
///
/// This struct conforms to the `Codable`, `Equatable`, and `Sendable` protocols,
/// allowing it to be encoded/decoded to different representations, compared for equality,
/// and safely transferred between processes.
public struct MachineIdentifier: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case ecID = "ECID"
  }

  /// A unique 64-bit identifier for the machine.
  public let ecID: UInt64
}
