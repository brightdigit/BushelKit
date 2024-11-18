//
//  Snapshot.swift
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

public import BushelFoundation
public import Foundation

public struct Snapshot: Codable, Identifiable, Sendable {
  public var name: String
  public let id: UUID
  public let snapshotterID: SnapshotterID
  public let createdAt: Date
  public var notes: String
  public var operatingSystemVersion: OperatingSystemVersion?
  public var buildVersion: String?
  public var isDiscardable: Bool
  public init(
    name: String,
    id: UUID,
    snapshotterID: SnapshotterID,
    createdAt: Date,
    isDiscardable: Bool,
    notes: String = "",
    operatingSystemVersion: OperatingSystemVersion? = nil,
    buildVersion: String? = nil
  ) {
    self.name = name
    self.id = id
    self.snapshotterID = snapshotterID
    self.createdAt = createdAt
    self.isDiscardable = isDiscardable
    self.notes = notes
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
  }
}

extension Snapshot {
  internal struct OperatingSystem: OperatingSystemInstalled {
    internal let operatingSystemVersion: OperatingSystemVersion
    internal let buildVersion: String?

    internal init(operatingSystemVersion: OperatingSystemVersion, buildVersion: String?) {
      self.operatingSystemVersion = operatingSystemVersion
      self.buildVersion = buildVersion
    }

    internal init?(operatingSystemVersion: OperatingSystemVersion?, buildVersion: String?) {
      guard let operatingSystemVersion else {
        return nil
      }
      self.init(operatingSystemVersion: operatingSystemVersion, buildVersion: buildVersion)
    }
  }

  public var operatingSystemInstalled: (any OperatingSystemInstalled)? {
    OperatingSystem(
      operatingSystemVersion: self.operatingSystemVersion,
      buildVersion: self.buildVersion
    )
  }

  public func updatingWith(name newName: String, notes newNotes: String) -> Snapshot {
    Snapshot(
      name: newName,
      id: id,
      snapshotterID: snapshotterID,
      createdAt: createdAt,
      isDiscardable: isDiscardable,
      notes: newNotes,
      operatingSystemVersion: operatingSystemVersion,
      buildVersion: buildVersion
    )
  }
}
