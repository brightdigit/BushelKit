//
//  HardwareModel.swift
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

internal import Foundation
public import OSVer

/// A struct representing a hardware model.
public struct HardwareModel: Codable, Equatable, Sendable {
  /// The coding keys used for encoding and decoding the hardware model.
  public enum CodingKeys: String, CodingKey {
    case dataRepresentationVersion = "DataRepresentationVersion"
    case minimumSupportedOS = "MinimumSupportedOS"
    case platformVersion = "PlatformVersion"
  }

  /// The data representation version of the hardware model.
  public let dataRepresentationVersion: Int

  /// The minimum supported operating system version for the hardware model.
  public let minimumSupportedOS: OSVer

  /// The platform version of the hardware model.
  public let platformVersion: Int
}
