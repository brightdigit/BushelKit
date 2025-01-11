//
//  PhysicalDrive.swift
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

/// Represents a physical drive on the system.
public struct PhysicalDrive: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case isInternalDisk = "is_internal_disk"
    case mediaName = "media_name"
    case mediumType = "medium_type"
    case partitionMapType = "partition_map_type"
  }

  /// Indicates whether the drive is an internal disk or not.
  public let isInternalDisk: PrivateFramework
  /// The name of the media.
  public let mediaName: String
  /// The type of the media.
  public let mediumType: String
  /// The type of the partition map.
  public let partitionMapType: String

  /// Initializes a `PhysicalDrive` instance.
  /// - Parameters:
  ///   - isInternalDisk: Indicates whether the drive is an internal disk or not.
  ///   - mediaName: The name of the media.
  ///   - mediumType: The type of the media.
  ///   - partitionMapType: The type of the partition map.
  public init(
    isInternalDisk: PrivateFramework,
    mediaName: String,
    mediumType: String,
    partitionMapType: String
  ) {
    self.isInternalDisk = isInternalDisk
    self.mediaName = mediaName
    self.mediumType = mediumType
    self.partitionMapType = partitionMapType
  }
}
