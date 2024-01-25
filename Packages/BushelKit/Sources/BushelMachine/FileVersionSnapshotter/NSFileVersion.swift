//
// NSFileVersion.swift
// Copyright (c) 2024 BrightDigit.
//

#if !os(Linux)
  import Foundation

  extension NSFileVersion {
    @available(iOS, unavailable)
    static func addOfItem(
      at url: URL,
      withContentsOf contentsURL: URL,
      options: SnapshotOptions
    ) throws -> NSFileVersion {
      let version = try NSFileVersion.addOfItem(
        at: url,
        withContentsOf: contentsURL,
        options: .init(options: options)
      )

      if options.contains(.discardable) {
        version.isDiscardable = true
      }

      return version
    }

    static func version(
      itemAt url: URL,
      forPersistentIdentifierData identifierData: Data
    ) throws -> NSFileVersion {
      guard let persistentIdentifier = try NSKeyedUnarchiver.unarchivedObject(
        ofClasses: [NSObject.self],
        from: identifierData
      ) as? NSObject else {
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

    func writePersistentIdentifier(to snapshotFileURL: URL) throws {
      let persistentIdentifierData = try NSKeyedArchiver.archivedData(
        withRootObject: self.persistentIdentifier,
        requiringSecureCoding: false
      )

      try persistentIdentifierData.write(to: snapshotFileURL)
    }
  }

  extension NSFileVersion.AddingOptions {
    init(options: SnapshotOptions) {
      self = options.contains(.byMoving) ? [.byMoving] : []
    }
  }
#endif
