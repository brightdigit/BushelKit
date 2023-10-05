//
// SnapshotProvider.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore

public protocol SnapshotProvider {
  func snapshotter<MachineType: Machine>(
    withID id: SnapshotterID,
    for machineType: MachineType.Type
  ) -> (any Snapshotter<MachineType>)?
}
