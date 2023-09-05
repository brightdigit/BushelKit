//
// MachineSnapshot.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public extension MachineSnapshot {
  static func preview(
    timeIntervalSinceNow: TimeInterval,
    id: Data? = nil,
    url: URL? = nil,
    isDiscardable: Bool = false,
    notes: String = ""
  ) -> MachineSnapshot {
    MachineSnapshot(
      id: id ?? Data.random(), typeID: "",
      url: url ?? URL.randomFile(),
      isDiscardable: isDiscardable,
      date: Date(timeIntervalSinceNow: timeIntervalSinceNow),
      notes: notes
    )
  }
}
