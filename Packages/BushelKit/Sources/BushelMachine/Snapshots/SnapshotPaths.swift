//
// SnapshotPaths.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public struct SnapshotPaths {
  public let snapshottingSourceURL: URL
  public let snapshotCollectionURL: URL

  public init(machinePathURL: URL) {
    self.init(
      snapshottingSourceURL: machinePathURL,
      snapshotCollectionURL: machinePathURL.appendingPathComponent(Paths.snapshotsDirectoryName)
    )
  }

  public init(snapshottingSourceURL: URL, snapshotCollectionURL: URL) {
    self.snapshottingSourceURL = snapshottingSourceURL
    self.snapshotCollectionURL = snapshotCollectionURL
  }
}
