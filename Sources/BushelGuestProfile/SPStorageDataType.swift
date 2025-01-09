//
//  SPStorageDataType.swift
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

/// Represents a data type used for storage-related information.
public struct SPStorageDataType: Codable, Equatable, Sendable {
  /// Enumeration of the coding keys used for the `SPStorageDataType` struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bsdName = "bsd_name"
    case fileSystem = "file_system"
    case freeSpaceInBytes = "free_space_in_bytes"
    case ignoreOwnership = "ignore_ownership"
    case mountPoint = "mount_point"
    case physicalDrive = "physical_drive"
    case sizeInBytes = "size_in_bytes"
    case volumeUUID = "volume_uuid"
    case writable
  }

  /// The name of the storage data type.
  public let name: String
  /// The BSD (Berkeley Software Distribution) name of the storage data type.
  public let bsdName: String
  /// The file system of the storage data type.
  public let fileSystem: String
  /// The free space in bytes of the storage data type.
  public let freeSpaceInBytes: Int
  /// The ignore ownership setting of the storage data type.
  public let ignoreOwnership: PrivateFramework
  /// The mount point of the storage data type.
  public let mountPoint: String
  /// The physical drive of the storage data type.
  public let physicalDrive: PhysicalDrive
  /// The size in bytes of the storage data type.
  public let sizeInBytes: Int
  /// The volume UUID of the storage data type.
  public let volumeUUID: String
  /// The writable setting of the storage data type.
  public let writable: PrivateFramework

  /// Initializes an `SPStorageDataType` instance.
  /// - Parameters:
  ///   - name: The name of the storage data type.
  ///   - bsdName: The BSD (Berkeley Software Distribution) name of the storage data type.
  ///   - fileSystem: The file system of the storage data type.
  ///   - freeSpaceInBytes: The free space in bytes of the storage data type.
  ///   - ignoreOwnership: The ignore ownership setting of the storage data type.
  ///   - mountPoint: The mount point of the storage data type.
  ///   - physicalDrive: The physical drive of the storage data type.
  ///   - sizeInBytes: The size in bytes of the storage data type.
  ///   - volumeUUID: The volume UUID of the storage data type.
  ///   - writable: The writable setting of the storage data type.
  public init(
    name: String,
    bsdName: String,
    fileSystem: String,
    freeSpaceInBytes: Int,
    ignoreOwnership: PrivateFramework,
    mountPoint: String,
    physicalDrive: PhysicalDrive,
    sizeInBytes: Int,
    volumeUUID: String,
    writable: PrivateFramework
  ) {
    self.name = name
    self.bsdName = bsdName
    self.fileSystem = fileSystem
    self.freeSpaceInBytes = freeSpaceInBytes
    self.ignoreOwnership = ignoreOwnership
    self.mountPoint = mountPoint
    self.physicalDrive = physicalDrive
    self.sizeInBytes = sizeInBytes
    self.volumeUUID = volumeUUID
    self.writable = writable
  }
}
