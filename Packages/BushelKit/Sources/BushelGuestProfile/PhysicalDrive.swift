//
// PhysicalDrive.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - PhysicalDrive

public struct PhysicalDrive: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case isInternalDisk = "is_internal_disk"
    case mediaName = "media_name"
    case mediumType = "medium_type"
    case partitionMapType = "partition_map_type"
  }

  public let isInternalDisk: PrivateFramework
  public let mediaName: String
  public let mediumType: String
  public let partitionMapType: String

  public init(
    isInternalDisk: PrivateFramework,
    mediaName: String,
    mediumType: String,
    partitionMapType: String
  ) {
    self.isInternalDisk = isInternalDisk
    self.mediaName = mediaName
    self.mediumType = mediumType
    self.partitionMapType = partitionMapType
  }
}
