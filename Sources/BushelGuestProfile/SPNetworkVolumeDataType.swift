//
//  SPNetworkVolumeDataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

// MARK: - SPNetworkVolumeDataType

public struct SPNetworkVolumeDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
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

  public init(
    name: String,
    spnetworkvolumeAutomounted: String,
    spnetworkvolumeFsmtnonname: String,
    spnetworkvolumeFstypename: String,
    spnetworkvolumeMntfromname: String
  ) {
    self.name = name
    self.spnetworkvolumeAutomounted = spnetworkvolumeAutomounted
    self.spnetworkvolumeFsmtnonname = spnetworkvolumeFsmtnonname
    self.spnetworkvolumeFstypename = spnetworkvolumeFstypename
    self.spnetworkvolumeMntfromname = spnetworkvolumeMntfromname
  }
}
