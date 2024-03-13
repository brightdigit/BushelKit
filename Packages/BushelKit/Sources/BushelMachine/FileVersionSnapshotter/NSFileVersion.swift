//
// NSFileVersion.swift
// Copyright (c) 2024 BrightDigit.
//

#if !os(Linux)
  import Foundation

  extension NSFileVersion {
    struct VersionDataSet {
      let fileVersion: NSFileVersion
      let url: URL

      func remove(with fileManager: FileManager) throws {
        try fileVersion.remove()
        try fileManager.removeItem(at: url)
      }
    }

    var persistentIdentifierData: Data {
      get throws {
        try NSKeyedArchiver.archivedData(
          withRootObject: self.persistentIdentifier,
          requiringSecureCoding: false
        )
      }
    }

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
      let unarchiver: NSKeyedUnarchiver
      do {
        unarchiver = try NSKeyedUnarchiver(forReadingFrom: identifierData)
      } catch {
        throw SnapshotError.innerError(error)
      }
      unarchiver.requiresSecureCoding = false
      guard let persistentIdentifier: any Sendable =
        unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) else {
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
    ) throws -> VersionDataSet {
      let identifierDataFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(snapshotID.uuidString)
        .appendingPathExtension("bshsnapshot")
      let identifierData = try Data(contentsOf: identifierDataFileURL)

      let version = try Self.version(
        itemAt: paths.snapshottingSourceURL,
        forPersistentIdentifierData: identifierData
      )

      return .init(fileVersion: version, url: identifierDataFileURL)
    }

    func writePersistentIdentifier(to snapshotFileURL: URL) throws {
      try persistentIdentifierData.write(to: snapshotFileURL)
    }
  }

  extension NSFileVersion.AddingOptions {
    init(options: SnapshotOptions) {
      self = options.contains(.byMoving) ? [.byMoving] : []
    }
  }
#endif
