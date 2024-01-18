//
// OperatingSystemVersion.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

extension OperatingSystemVersion: CustomStringConvertible,
  Hashable,
  CustomDebugStringConvertible,
  Codable,
  Comparable {
  enum CodingKeys: String, CodingKey {
    case majorVersion
    case minorVersion
    case patchVersion
  }

  public enum Error: Swift.Error, Equatable {
    case invalidFormatString(String)
  }

  private static let codeNames: [Int: String] = [
    11: "Big Sur",
    12: "Monterey",
    13: "Ventura",
    14: "Sonoma"
  ]

  public var macOSReleaseName: String? {
    Self.macOSReleaseName(majorVersion: majorVersion)
  }

  public var description: String {
    [majorVersion, minorVersion, patchVersion].map(String.init).joined(separator: ".")
  }

  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "OperatingSystemVersion(majorVersion: \(majorVersion), minorVersion: \(minorVersion), patchVersion: \(patchVersion))"
  }

  public init(string: String) throws {
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

  public init(compositeFrom decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let majorVersion: Int = try container.decode(Int.self, forKey: .majorVersion)
    let minorVersion: Int = try container.decode(Int.self, forKey: .minorVersion)
    let patchVersion: Int = try container.decode(Int.self, forKey: .patchVersion)
    self.init(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
  }

  public init(container: SingleValueDecodingContainer) throws {
    let value = try container.decode(String.self)
    try self.init(string: value)
  }

  public init(stringFrom decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    try self.init(container: container)
  }

  public init(from decoder: Decoder) throws {
    let throwingError: Swift.Error?
    if let container = Self.singleStringDecodingContainer(from: decoder) {
      do {
        try self.init(container: container)
        return
      } catch {
        throwingError = error
      }
    } else {
      throwingError = nil
    }
    do {
      try self.init(compositeFrom: decoder)
    } catch {
      throw throwingError ?? error
    }
  }

  public static func < (lhs: OperatingSystemVersion, rhs: OperatingSystemVersion) -> Bool {
    guard lhs.majorVersion == rhs.majorVersion else {
      return lhs.majorVersion < rhs.majorVersion
    }
    guard lhs.minorVersion == rhs.minorVersion else {
      return lhs.minorVersion < rhs.minorVersion
    }
    return lhs.patchVersion < rhs.patchVersion
  }

  public static func macOSReleaseName(majorVersion: Int) -> String? {
    Self.codeNames[majorVersion]
  }

  static func singleStringDecodingContainer(from decoder: Decoder) -> SingleValueDecodingContainer? {
    try? decoder.singleValueContainer()
  }

  public static func == (
    lhs: OperatingSystemVersion,
    rhs: OperatingSystemVersion
  ) -> Bool {
    lhs.majorVersion == rhs.majorVersion &&
      lhs.minorVersion == rhs.minorVersion &&
      lhs.patchVersion == rhs.patchVersion
  }

  private func encodeAsString(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()

    try container.encode(self.description)
  }

  private func encodeAsComposite(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Self.CodingKeys.self)
    try container.encode(self.majorVersion, forKey: .majorVersion)
    try container.encode(self.minorVersion, forKey: .minorVersion)
    try container.encode(self.patchVersion, forKey: .patchVersion)
  }

  public func encode(to encoder: Encoder) throws {
    let throwingError: Swift.Error
    do {
      try encodeAsString(to: encoder)
      return
    } catch {
      throwingError = error
    }
    do {
      try encodeAsComposite(to: encoder)
    } catch {
      throw throwingError
    }
  }

  public func hash(into hasher: inout Hasher) {
    majorVersion.hash(into: &hasher)
    minorVersion.hash(into: &hasher)
    patchVersion.hash(into: &hasher)
  }
}
