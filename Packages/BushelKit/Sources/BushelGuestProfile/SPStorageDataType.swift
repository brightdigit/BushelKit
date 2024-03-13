//
// SPStorageDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPStorageDataType

public struct SPStorageDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bsdName = "bsd_name"
    case fileSystem = "file_system"
    case freeSpaceInBytes = "free_space_in_bytes"
    case ignoreOwnership = "ignore_ownership"
    case mountPoint = "mount_point"
    case physicalDrive = "physical_drive"
    case sizeInBytes = "size_in_bytes"
    case volumeUUID = "volume_uuid"
    case writable
  }

  public let name: String
  public let bsdName: String
  public let fileSystem: String
  public let freeSpaceInBytes: Int
  public let ignoreOwnership: PrivateFramework
  public let mountPoint: String
  public let physicalDrive: PhysicalDrive
  public let sizeInBytes: Int
  public let volumeUUID: String
  public let writable: PrivateFramework

  // swiftlint:disable:next line_length
  public init(name: String, bsdName: String, fileSystem: String, freeSpaceInBytes: Int, ignoreOwnership: PrivateFramework, mountPoint: String, physicalDrive: PhysicalDrive, sizeInBytes: Int, volumeUUID: String, writable: PrivateFramework) {
    self.name = name
    self.bsdName = bsdName
    self.fileSystem = fileSystem
    self.freeSpaceInBytes = freeSpaceInBytes
    self.ignoreOwnership = ignoreOwnership
    self.mountPoint = mountPoint
    self.physicalDrive = physicalDrive
    self.sizeInBytes = sizeInBytes
    self.volumeUUID = volumeUUID
    self.writable = writable
  }
}
