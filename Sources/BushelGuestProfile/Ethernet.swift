//
//  Ethernet.swift
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

/// Represents an Ethernet connection.
public struct Ethernet: Codable, Equatable, Sendable {
  /// Coding keys for `Ethernet` struct.
  public enum CodingKeys: String, CodingKey {
    case macAddress = "MAC Address"
    case mediaOptions = "MediaOptions"
    case mediaSubType = "MediaSubType"
  }

  /// The MAC address of the Ethernet connection.
  public let macAddress: String
  /// The media options of the Ethernet connection.
  public let mediaOptions: [String]
  /// The media sub-type of the Ethernet connection.
  public let mediaSubType: String

  /// Initializes an `Ethernet` instance.
  /// - Parameters:
  ///   - macAddress: The MAC address of the Ethernet connection.
  ///   - mediaOptions: The media options of the Ethernet connection.
  ///   - mediaSubType: The media sub-type of the Ethernet connection.
  public init(
    macAddress: String,
    mediaOptions: [String],
    mediaSubType: String
  ) {
    self.macAddress = macAddress
    self.mediaOptions = mediaOptions
    self.mediaSubType = mediaSubType
  }
}
