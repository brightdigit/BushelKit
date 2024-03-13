//
// SnapshotFileUpdate.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelCore
  import BushelLogging
  import Foundation

  struct SnapshotFileUpdate {
    let filesToDelete: [URL]
    let versionsToAdd: [NSFileVersion]
  }
#endif
