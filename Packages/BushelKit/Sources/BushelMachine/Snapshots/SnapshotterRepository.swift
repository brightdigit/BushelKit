//
// SnapshotterRepository.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore

public struct SnapshotterRepository: SnapshotProvider {
  public init(factories: [any SnapshotterFactory] = []) {
    let uniqueKeysWithValues = factories.map {
      (type(of: $0).systemID, $0)
    }

    self.init(dictionary: .init(uniqueKeysWithValues: uniqueKeysWithValues))
  }

  internal init(dictionary: [SnapshotterID: any SnapshotterFactory]) {
    self.dictionary = dictionary
  }

  private let dictionary: [SnapshotterID: any SnapshotterFactory]
  public func snapshotter<MachineType: Machine>(withID id: SnapshotterID, for machineType: MachineType.Type) -> (any Snapshotter<MachineType>)? {
    guard let anySnapshotter = dictionary[id] else {
      return nil
    }

    return anySnapshotter.snapshotter(supports: machineType)
  }
}
