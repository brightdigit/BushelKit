//
//  SPNetworkVolumeDataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

/// Represents a data type for a network volume in the SP (Shared Preferences) system.
public struct SPNetworkVolumeDataType: Codable, Equatable, Sendable {
  /// The coding keys used for the Codable protocol.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spnetworkvolumeAutomounted = "spnetworkvolume_automounted"
    case spnetworkvolumeFsmtnonname = "spnetworkvolume_fsmtnonname"
    case spnetworkvolumeFstypename = "spnetworkvolume_fstypename"
    case spnetworkvolumeMntfromname = "spnetworkvolume_mntfromname"
  }

  /// The name of the network volume.
  public let name: String
  /// Indicates whether the network volume is automounted.
  public let spnetworkvolumeAutomounted: String
  /// The non-name file system type of the network volume.
  public let spnetworkvolumeFsmtnonname: String
  /// The name of the file system type of the network volume.
  public let spnetworkvolumeFstypename: String
  /// The name of the mount point for the network volume.
  public let spnetworkvolumeMntfromname: String

  /// Initializes a new instance of `SPNetworkVolumeDataType`.
  ///
  /// - Parameters:
  ///   - name: The name of the network volume.
  ///   - spnetworkvolumeAutomounted: Indicates whether the network volume is automounted.
  ///   - spnetworkvolumeFsmtnonname: The non-name file system type of the network volume.
  ///   - spnetworkvolumeFstypename: The name of the file system type of the network volume.
  ///   - spnetworkvolumeMntfromname: The name of the mount point for the network volume.
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
