//
// SnapshotError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

internal enum SnapshotError: Error {
  case innerError(Error)
  case missingSnapshotVersionID(UUID)
  case missingSnapshotVersionAt(URL, forPersistentIdentifier: Any)
  case missingSnapshotFile(UUID)
  case unarchiveError(Data)

  static func inner(error: Error) -> SnapshotError {
    if let snapshotError = error as? SnapshotError {
      snapshotError
    } else {
      .innerError(error)
    }
  }
}
