//
// MachineSnapshot.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MachineSnapshot: Codable, Identifiable, Equatable {
  public let id: Data
  public let typeID: String
  public let url: URL
  public let date: Date
  public let isDiscardable: Bool
  public var notes: String

  public init(id: Data, typeID: String, url: URL, isDiscardable: Bool, date: Date? = nil, notes: String = "") {
    let date = date ?? Date()
    self.id = id
    self.typeID = typeID
    self.date = date
    self.url = url
    self.isDiscardable = isDiscardable
    self.notes = notes
  }
}

public extension MachineSnapshot {
  init(fileVersion: FileVersion) throws {
    let id = try fileVersion.getIdentifier()
    self.init(
      id: id,
      typeID: type(of: fileVersion).typeID,
      url: fileVersion.url,
      isDiscardable: fileVersion.isDiscardable,
      date: fileVersion.modificationDate
    )
  }
}
