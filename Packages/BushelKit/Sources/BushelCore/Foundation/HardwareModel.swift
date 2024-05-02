//
// HardwareModel.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation
import OperatingSystemVersion

public struct HardwareModel: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case dataRepresentationVersion = "DataRepresentationVersion"
    case minimumSupportedOS = "MinimumSupportedOS"
    case platformVersion = "PlatformVersion"
  }

  public let dataRepresentationVersion: Int
  public let minimumSupportedOS: OperatingSystemVersion
  public let platformVersion: Int
}
