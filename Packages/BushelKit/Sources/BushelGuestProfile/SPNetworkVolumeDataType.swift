//
// SPNetworkVolumeDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPNetworkVolumeDataType

public struct SPNetworkVolumeDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spnetworkvolumeAutomounted = "spnetworkvolume_automounted"
    case spnetworkvolumeFsmtnonname = "spnetworkvolume_fsmtnonname"
    case spnetworkvolumeFstypename = "spnetworkvolume_fstypename"
    case spnetworkvolumeMntfromname = "spnetworkvolume_mntfromname"
  }

  public let name: String
  public let spnetworkvolumeAutomounted: String
  public let spnetworkvolumeFsmtnonname: String
  public let spnetworkvolumeFstypename: String
  public let spnetworkvolumeMntfromname: String

  // swiftlint:disable:next line_length
  public init(name: String, spnetworkvolumeAutomounted: String, spnetworkvolumeFsmtnonname: String, spnetworkvolumeFstypename: String, spnetworkvolumeMntfromname: String) {
    self.name = name
    self.spnetworkvolumeAutomounted = spnetworkvolumeAutomounted
    self.spnetworkvolumeFsmtnonname = spnetworkvolumeFsmtnonname
    self.spnetworkvolumeFstypename = spnetworkvolumeFstypename
    self.spnetworkvolumeMntfromname = spnetworkvolumeMntfromname
  }
}
