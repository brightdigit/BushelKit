//
// FileManager.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelCore
  import BushelLogging
  import Foundation

  extension FileManager {
    func fileUpdates(
      atDirectoryURL snapshotCollectionURL: URL,
      fromVersions versions: [NSFileVersion],
      logger: Logger
    ) throws -> SnapshotFileUpdate {
      let snapshotFileDataDictionary: [String: Data]
      let snapshotCollectionDirectoryExists =
        self.directoryExists(at: snapshotCollectionURL) == .directoryExists
      if snapshotCollectionDirectoryExists {
        snapshotFileDataDictionary = try self.dataDictionary(
          directoryAt: snapshotCollectionURL
        )
      } else {
        snapshotFileDataDictionary = [:]
      }
      let dataLookup = Dictionary(grouping: snapshotFileDataDictionary, by: { $0.value }).mapValues {
        $0.map(\.key)
      }

      var filesToKeep = [String]()
      var versionsToAdd = [NSFileVersion]()

      for version in versions {
        let persistentIdentifierData: Data
        do {
          persistentIdentifierData = try version.persistentIdentifierData
        } catch {
          logger.error("Unable to fetch persistentIdentifierData: \(error.localizedDescription)")
          continue
        }

        let files = dataLookup[persistentIdentifierData]
        if let fileToKeep = files?.first {
          filesToKeep.append(fileToKeep)
        } else {
          versionsToAdd.append(version)
        }
      }

      let filesToDelete = Set(snapshotFileDataDictionary.keys).subtracting(filesToKeep).map(
        snapshotCollectionURL.appendingPathComponent(_:)
      )

      return SnapshotFileUpdate(filesToDelete: filesToDelete, versionsToAdd: versionsToAdd)
    }

    func filenameUUIDs(atDirectoryURL snapshotCollectionURL: URL) throws -> [UUID] {
      let snapshotCollectionDirectoryExists =
        self.directoryExists(at: snapshotCollectionURL) == .directoryExists
      let snapshotFileURLs = try snapshotCollectionDirectoryExists ?
        self.contentsOfDirectory(
          at: snapshotCollectionURL,
          includingPropertiesForKeys: []
        ) : []
      let snapshotIDs = snapshotFileURLs
        .map { $0.deletingPathExtension().lastPathComponent }
        .compactMap(UUID.init(uuidString:))
      assert(snapshotFileURLs.count == snapshotIDs.count)
      return snapshotIDs
    }
  }
#endif
