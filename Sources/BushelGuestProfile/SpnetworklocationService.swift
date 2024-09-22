//
//  SpnetworklocationService.swift
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

// MARK: - SpnetworklocationService

public struct SpnetworklocationService: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bsdDeviceName = "bsd_device_name"
    case hardwareAddress = "hardware_address"
    case iPv4 = "IPv4"
    case iPv6 = "IPv6"
    case proxies = "Proxies"
    case type
  }

  public let name: String
  public let bsdDeviceName: String
  public let hardwareAddress: String
  public let iPv4: IPV
  public let iPv6: IPV
  public let proxies: Proxies
  public let type: String

  public init(
    name: String,
    bsdDeviceName: String,
    hardwareAddress: String,
    iPv4: IPV,
    iPv6: IPV,
    proxies: Proxies,
    type: String
  ) {
    self.name = name
    self.bsdDeviceName = bsdDeviceName
    self.hardwareAddress = hardwareAddress
    self.iPv4 = iPv4
    self.iPv6 = iPv6
    self.proxies = proxies
    self.type = type
  }
}
