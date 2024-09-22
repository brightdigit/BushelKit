//
//  SPSoftwareDataType.swift
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

// MARK: - SPSoftwareDataType

public struct SPSoftwareDataType: Codable, Equatable, Sendable {
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

  public let name: String
  public let bootMode: String
  public let bootVolume: String
  public let kernelVersion: String
  public let localHostName: String
  public let osVersion: String
  public let secureVM: String
  public let systemIntegrity: String
  public let uptime: String
  public let userName: String

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
