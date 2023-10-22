//
// NSFileVersion.swift
// Copyright (c) 2023 BrightDigit.
//

#if !os(Linux)
  import Foundation

  extension NSFileVersion {
    static func version(
      itemAt url: URL,
      forPersistentIdentifierData identifierData: Data
    ) throws -> NSFileVersion {
      guard let persistentIdentifier = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
        identifierData
      ) else {
        throw SnapshotError.unarchiveError(identifierData)
      }
      guard let version = self.version(itemAt: url, forPersistentIdentifier: persistentIdentifier) else {
        throw SnapshotError.missingSnapshotVersionAt(url, forPersistentIdentifier: persistentIdentifier)
      }
      return version
    }

    static func version(
      withID snapshotID: UUID,
      basedOn paths: SnapshotPaths
    ) throws -> NSFileVersion {
      let identifierDataFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(snapshotID.uuidString)
        .appendingPathExtension("bshsnapshot")
      let identifierData = try Data(contentsOf: identifierDataFileURL)

      return try Self.version(
        itemAt: paths.snapshottingSourceURL,
        forPersistentIdentifierData: identifierData
      )
    }
  }

  extension NSFileVersion.AddingOptions {
    init(options: SnapshotOptions) {
      self = options.contains(.byMoving) ? [.byMoving] : []
    }
  }
#endif
