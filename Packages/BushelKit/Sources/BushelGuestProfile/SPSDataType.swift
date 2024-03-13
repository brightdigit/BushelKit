//
// SPSDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPSDataType

public struct SPSDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case archKind = "arch_kind"
    case lastModified
    case obtainedFrom = "obtained_from"
    case path
    case version
    case info
    case privateFramework = "private_framework"
  }

  public let name: String
  public let archKind: ArchKind?
  public let lastModified: Date
  public let obtainedFrom: ObtainedFrom
  public let path: String
  public let version: String?
  public let info: String?
  public let privateFramework: PrivateFramework?

  // swiftlint:disable:next line_length
  public init(name: String, archKind: ArchKind?, lastModified: Date, obtainedFrom: ObtainedFrom, path: String, version: String?, info: String?, privateFramework: PrivateFramework?) {
    self.name = name
    self.archKind = archKind
    self.lastModified = lastModified
    self.obtainedFrom = obtainedFrom
    self.path = path
    self.version = version
    self.info = info
    self.privateFramework = privateFramework
  }
}
