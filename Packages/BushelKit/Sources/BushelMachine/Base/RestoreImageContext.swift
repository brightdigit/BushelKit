//
// RestoreImageContext.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct MachineContext: Codable {
  public let url: URL
  public let id: UUID
  public var restoreImageID: UUID
  public var operatingSystem: OperatingSystemDetails
}

public struct RestoreImageLibraryContext: Codable {
  public let url: URL
}

public struct RestoreImageContext: Codable {
  public let name: String
  public let id: UUID
  public let metadata: ImageMetadata
  public let url: URL
}
