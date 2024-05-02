//
// MachineStorageSpecification.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct MachineStorageSpecification: Codable, Identifiable, Equatable, Sendable {
  public let id: UUID
  public var size: UInt64
  public var label: String

  // swiftlint:disable:next function_default_parameter_at_end
  public init(id: UUID = .init(), label: String, size: UInt64) {
    self.id = id
    self.label = label
    self.size = size
  }
}

public extension MachineStorageSpecification {
  // swiftlint:disable:next force_unwrapping
  private static let defaultPrimaryID = UUID(uuidString: "70fe323b-efc9-410f-b642-bc8e15636a49")!
  internal static let defaultPrimary: MachineStorageSpecification = .init(
    id: Self.defaultPrimaryID, label: "", size: Self.defaultSize
  )
  static let defaultSize = UInt64(64 * 1024 * 1024 * 1024)
  static func `default`(forSystem system: any MachineSystem) -> MachineStorageSpecification { .init(
    label: system.defaultStorageLabel,
    size: UInt64(64 * 1024 * 1024 * 1024)
  )
  }
}
