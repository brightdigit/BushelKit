//
// OperatingSystemVersion.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

extension OperatingSystemVersion: CustomStringConvertible, Codable, Hashable, CustomDebugStringConvertible {
  public func hash(into hasher: inout Hasher) {
    majorVersion.hash(into: &hasher)
    minorVersion.hash(into: &hasher)
    patchVersion.hash(into: &hasher)
  }

  public static func == (
    lhs: OperatingSystemVersion,
    rhs: OperatingSystemVersion
  ) -> Bool {
    lhs.majorVersion == rhs.majorVersion &&
      lhs.minorVersion == rhs.minorVersion &&
      lhs.patchVersion == rhs.patchVersion
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(description)
  }

  public enum Error: Swift.Error {
    case invalidFormatString(String)
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)

    try self.init(string: string)
  }

  init(string: String) throws {
    let components = string.components(separatedBy: ".").compactMap(Int.init)

    guard components.count == 2 || components.count == 3 else {
      throw Self.Error.invalidFormatString(string)
    }

    self.init(
      majorVersion: components[0],
      minorVersion: components[1],
      patchVersion: components.count == 3 ? components[2] : 0
    )
  }

  public var description: String {
    [majorVersion, minorVersion, patchVersion].map(String.init).joined(separator: ".")
  }

  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "OperatingSystemVersion(majorVersion: \(majorVersion), minorVersion: \(minorVersion), patchVersion: \(patchVersion)"
  }
}
