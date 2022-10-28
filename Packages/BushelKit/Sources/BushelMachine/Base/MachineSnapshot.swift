//
// MachineSnapshot.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct MachineSnapshot: Codable, Identifiable {
  public init(id: Data, url: URL, isDiscardable: Bool, date: Date? = nil, notes: String = "") {
    let date = date ?? Date()
    self.id = id
    self.date = date
    self.url = url
    self.isDiscardable = isDiscardable
    self.notes = notes
  }

  public let id: Data
  public let url: URL
  public let date: Date
  public let isDiscardable: Bool
  public var notes: String
}

#if os(macOS)
  public extension MachineSnapshot {
    init(fileVersion: NSFileVersion) throws {
      let id = try fileVersion.getArchivedPersistentIdentifier()
      self.init(
        id: id,
        url: fileVersion.url,
        isDiscardable: fileVersion.isDiscardable,
        date: fileVersion.modificationDate
      )
    }
  }
#endif
