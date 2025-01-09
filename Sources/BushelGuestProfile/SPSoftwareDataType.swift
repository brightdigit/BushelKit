//
//  SPSoftwareDataType.swift
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

// MARK: - SPSoftwareDataType

/// A struct representing software data type.
public struct SPSoftwareDataType: Codable, Equatable, Sendable {
  /// Coding keys used for encoding and decoding the struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bootMode = "boot_mode"
    case bootVolume = "boot_volume"
    case kernelVersion = "kernel_version"
    case localHostName = "local_host_name"
    case osVersion = "os_version"
    case secureVM = "secure_vm"
    case systemIntegrity = "system_integrity"
    case uptime
    case userName = "user_name"
  }

  /// The name of the software.
  public let name: String
  /// The boot mode of the software.
  public let bootMode: String
  /// The boot volume of the software.
  public let bootVolume: String
  /// The kernel version of the software.
  public let kernelVersion: String
  /// The local host name of the software.
  public let localHostName: String
  /// The operating system version of the software.
  public let osVersion: String
  /// The secure VM status of the software.
  public let secureVM: String
  /// The system integrity of the software.
  public let systemIntegrity: String
  /// The uptime of the software.
  public let uptime: String
  /// The user name of the software.
  public let userName: String

  /// Initializes a new `SPSoftwareDataType` instance.
  /// - Parameters:
  ///   - name: The name of the software.
  ///   - bootMode: The boot mode of the software.
  ///   - bootVolume: The boot volume of the software.
  ///   - kernelVersion: The kernel version of the software.
  ///   - localHostName: The local host name of the software.
  ///   - osVersion: The operating system version of the software.
  ///   - secureVM: The secure VM status of the software.
  ///   - systemIntegrity: The system integrity of the software.
  ///   - uptime: The uptime of the software.
  ///   - userName: The user name of the software.
  public init(
    name: String,
    bootMode: String,
    bootVolume: String,
    kernelVersion: String,
    localHostName: String,
    osVersion: String,
    secureVM: String,
    systemIntegrity: String,
    uptime: String,
    userName: String
  ) {
    self.name = name
    self.bootMode = bootMode
    self.bootVolume = bootVolume
    self.kernelVersion = kernelVersion
    self.localHostName = localHostName
    self.osVersion = osVersion
    self.secureVM = secureVM
    self.systemIntegrity = systemIntegrity
    self.uptime = uptime
    self.userName = userName
  }
}
