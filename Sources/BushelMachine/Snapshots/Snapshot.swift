//
//  Snapshot.swift
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

public import BushelFoundation
public import Foundation
public import OSVer

/// Represents a snapshot of a system,
/// containing information about the system's state at a specific point in time.
public struct Snapshot: Codable, Identifiable, Sendable {
  /// The name of the snapshot.
  public var name: String

  /// The unique identifier of the snapshot.
  public let id: UUID

  /// The identifier of the snapshotter that created this snapshot.
  public let snapshotterID: SnapshotterID

  /// The date and time when the snapshot was created.
  public let createdAt: Date

  /// Any additional notes or comments about the snapshot.
  public var notes: String

  /// The version of the operating system installed at the time of the snapshot.
  public var operatingSystemVersion: OSVer?

  /// The build version of the operating system installed at the time of the snapshot.
  public var buildVersion: String?

  /// Indicates whether the snapshot is discardable or not.
  public var isDiscardable: Bool

  /// An optional screenshot associated with this snapshot.
  public var image: RecordedImage?

  /// Initializes a new `Snapshot` instance.
  /// - Parameters:
  ///   - name: The name of the snapshot.
  ///   - id: The unique identifier of the snapshot.
  ///   - snapshotterID: The identifier of the snapshotter that created this snapshot.
  ///   - createdAt: The date and time when the snapshot was created.
  ///   - isDiscardable: Indicates whether the snapshot is discardable or not.
  ///   - notes: Any additional notes or comments about the snapshot. Defaults to an empty string.
  ///   - operatingSystemVersion: The version of the operating system
  ///   installed at the time of the snapshot. Defaults to `nil`.
  ///   - buildVersion: The build version of the operating system installed at the time of the snapshot.
  ///   Defaults to `nil`.
  ///   - image: An optional screenshot associated with this snapshot. Defaults to `nil`.
  public init(
    name: String,
    id: UUID,
    snapshotterID: SnapshotterID,
    createdAt: Date,
    isDiscardable: Bool,
    notes: String = "",
    operatingSystemVersion: OSVer? = nil,
    buildVersion: String? = nil,
    image: RecordedImage? = nil
  ) {
    self.name = name
    self.id = id
    self.snapshotterID = snapshotterID
    self.createdAt = createdAt
    self.isDiscardable = isDiscardable
    self.notes = notes
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
    self.image = image
  }
}

extension Snapshot {
  /// Represents the operating system information installed at the time of the snapshot.
  internal struct OperatingSystem: OperatingSystemInstalled {
    /// The version of the operating system installed at the time of the snapshot.
    internal let operatingSystemVersion: OSVer

    /// The build version of the operating system installed at the time of the snapshot.
    internal let buildVersion: String?

    /// Initializes a new `OperatingSystem` instance.
    /// - Parameters:
    ///   - operatingSystemVersion: The version of the operating system
    ///   installed at the time of the snapshot.
    ///   - buildVersion: The build version of the operating system installed at the time of the snapshot.
    internal init(operatingSystemVersion: OSVer, buildVersion: String?) {
      self.operatingSystemVersion = operatingSystemVersion
      self.buildVersion = buildVersion
    }

    /// Initializes a new `OperatingSystem` instance with optional parameters.
    /// - Parameters:
    ///   - operatingSystemVersion: The version of the operating system installed
    ///   at the time of the snapshot. May be `nil`.
    ///   - buildVersion: The build version of the operating system
    ///   installed at the time of the snapshot. May be `nil`.
    internal init?(operatingSystemVersion: OSVer?, buildVersion: String?) {
      guard let operatingSystemVersion else {
        return nil
      }
      self.init(operatingSystemVersion: operatingSystemVersion, buildVersion: buildVersion)
    }
  }

  /// The operating system information installed at the time of the snapshot.
  public var operatingSystemInstalled: (any OperatingSystemInstalled)? {
    OperatingSystem(
      operatingSystemVersion: self.operatingSystemVersion,
      buildVersion: self.buildVersion
    )
  }

  /// Updates the snapshot with a new name and notes.
  /// - Parameters:
  ///   - newName: The new name for the snapshot.
  ///   - newNotes: The new notes for the snapshot.
  /// - Returns: A new `Snapshot` instance with the updated name and notes.
  public func updatingWith(name newName: String, notes newNotes: String) -> Snapshot {
    Snapshot(
      name: newName,
      id: self.id,
      snapshotterID: self.snapshotterID,
      createdAt: self.createdAt,
      isDiscardable: self.isDiscardable,
      notes: newNotes,
      operatingSystemVersion: self.operatingSystemVersion,
      buildVersion: self.buildVersion,
      image: self.image
    )
  }
}
