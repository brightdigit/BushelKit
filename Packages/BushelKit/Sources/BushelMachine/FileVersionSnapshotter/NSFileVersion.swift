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
    ) throws -> NSFileVersion? {
      guard let persistentIdentifier = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
        identifierData
      ) else {
        throw NSError()
      }
      return self.version(itemAt: url, forPersistentIdentifier: persistentIdentifier)
    }

    static func version(
      withID snapshotID: UUID,
      basedOn paths: SnapshotPaths
    ) throws -> NSFileVersion {
      let identifierDataFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(snapshotID.uuidString)
        .appendingPathExtension("bshsnapshot")
      let identifierData = try Data(contentsOf: identifierDataFileURL)

      guard let fileVersion = try Self.version(
        itemAt: paths.snapshottingSourceURL,
        forPersistentIdentifierData: identifierData
      ) else {
        throw NSError()
      }
      return fileVersion
    }
  }

  extension NSFileVersion.AddingOptions {
    init(options: SnapshotOptions) {
      self = options.contains(.byMoving) ? [.byMoving] : []
    }
  }
#endif
