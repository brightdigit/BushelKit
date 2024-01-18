//
// SnapshotError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

internal enum SnapshotError: Error, LocalizedError {
  case innerError(Error)
  case missingSnapshotVersionID(UUID)
  case missingSnapshotVersionAt(URL, forPersistentIdentifier: Any)
  case missingSnapshotFile(UUID)
  case unarchiveError(Data)

  var errorDescription: String? {
    Self.description(from: self)
  }

  static func inner(error: Error) -> SnapshotError {
    if let snapshotError = error as? SnapshotError {
      snapshotError
    } else {
      .innerError(error)
    }
  }

  static func description(from error: Error) -> String {
    guard let error = error as? SnapshotError else {
      assertionFailure()
      return error.localizedDescription
    }
    switch error {
    case let .innerError(error):
      assertionFailure(error.localizedDescription)
      return error.localizedDescription

    case let .missingSnapshotVersionID(id):
      return "Missing Snapshot Based on Info from ID: \(id)"
    case let .missingSnapshotVersionAt(url, forPersistentIdentifier: persistentIdentifier):
      return "Missing Snapshot at \(url) for \(persistentIdentifier)"
    case let .missingSnapshotFile(id):
      return "Missing Snapshot File with ID: \(id)"
    case let .unarchiveError(data):
      return "Unable to Parse Snapshot ID from Data: \(data)"
    }
  }
}
