//
//  SpnetworklocationService.swift
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

/// Represents a network location service.
public struct SpnetworklocationService: Codable, Equatable, Sendable {
  /// The coding keys for the `SpnetworklocationService` struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bsdDeviceName = "bsd_device_name"
    case hardwareAddress = "hardware_address"
    case iPv4 = "IPv4"
    case iPv6 = "IPv6"
    case proxies = "Proxies"
    case type
  }

  /// The name of the network location service.
  public let name: String
  /// The BSD device name of the network location service.
  public let bsdDeviceName: String
  /// The hardware address of the network location service.
  public let hardwareAddress: String
  /// The IPv4 information of the network location service.
  public let iPv4: IPV
  /// The IPv6 information of the network location service.
  public let iPv6: IPV
  /// The proxies of the network location service.
  public let proxies: Proxies
  /// The type of the network location service.
  public let type: String

  /// Initializes a new instance of `SpnetworklocationService`.
  ///
  /// - Parameters:
  ///   - name: The name of the network location service.
  ///   - bsdDeviceName: The BSD device name of the network location service.
  ///   - hardwareAddress: The hardware address of the network location service.
  ///   - iPv4: The IPv4 information of the network location service.
  ///   - iPv6: The IPv6 information of the network location service.
  ///   - proxies: The proxies of the network location service.
  ///   - type: The type of the network location service.
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
