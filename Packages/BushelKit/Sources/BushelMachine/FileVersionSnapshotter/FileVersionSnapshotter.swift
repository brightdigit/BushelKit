//
// FileVersionSnapshotter.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelCore
  import BushelLogging
  import Foundation

  struct FileVersionSnapshotter<MachineType: Machine>: Snapshotter, Loggable {
    static var loggingCategory: BushelLogging.Category {
      .machine
    }

    let fileManager: FileManager

    init(fileManager: FileManager = .default) {
      self.fileManager = fileManager
    }

    init(for _: MachineType.Type, fileManager: FileManager = .default) {
      self.init(fileManager: fileManager)
    }

    init(for _: MachineType, fileManager: FileManager = .default) {
      self.init(fileManager: fileManager)
    }

    func exportSnapshot(_ snapshot: Snapshot, from machine: MachineType, to url: URL) throws {
      let paths = try machine.beginSnapshot()
      let fileVersion = try (NSFileVersion.version(withID: snapshot.id, basedOn: paths)).fileVersion
      try fileVersion.replaceItem(at: url)
      let exportedConfiguration = MachineConfiguration(snapshot: snapshot, original: machine.configuration)
      let data = try JSON.encoder.encode(exportedConfiguration)
      let configurationFileURL = url.appendingPathComponent(URL.bushel.paths.machineJSONFileName)
      let newSnapshotsDirURL = url.appending(component: URL.bushel.paths.snapshotsDirectoryName)
      if self.fileManager.directoryExists(at: newSnapshotsDirURL) == .directoryExists {
        try self.fileManager.removeItem(at: newSnapshotsDirURL)
      }
      try self.fileManager.createEmptyDirectory(
        at: newSnapshotsDirURL,
        withIntermediateDirectories: false,
        deleteExistingFile: false
      )
      try data.write(to: configurationFileURL)
      machine.finishedWithSnapshot(snapshot, by: .export)
    }

    func restoreSnapshot(_ snapshot: Snapshot, to machine: MachineType) throws {
      let paths = try machine.beginSnapshot()
      let oldSnapshots = try self.fileManager.dataDictionary(directoryAt: paths.snapshotCollectionURL)

      let snapshotFileNameKey = [snapshot.id.uuidString, "bshsnapshot"].joined(separator: ".")

      guard let identifierData = oldSnapshots[snapshotFileNameKey] else {
        throw SnapshotError.missingSnapshotFile(snapshot.id)
      }

      Self.logger.debug("Retrieving snapshot \(snapshot.id) for machine at \(paths.snapshottingSourceURL)")
      let fileVersion = try Result {
        try NSFileVersion.version(
          itemAt: paths.snapshottingSourceURL,
          forPersistentIdentifierData: identifierData
        )
      }
      .mapError(
        SnapshotError.inner(error:)
      )
      .unwrap(
        or:
        SnapshotError.missingSnapshotVersionID(snapshot.id)
      )
      .get()

      do {
        Self.logger.debug(
          "Replacing with snapshot \(snapshot.id) for machine at \(paths.snapshottingSourceURL)"
        )
        try fileVersion.replaceItem(at: paths.snapshottingSourceURL)
        try self.fileManager.write(oldSnapshots, to: paths.snapshotCollectionURL)
      } catch {
        throw SnapshotError.inner(error: error)
      }
      machine.finishedWithSnapshot(snapshot, by: .restored)
    }

    func deleteSnapshot(_ snapshot: Snapshot, from machine: MachineType) throws {
      let paths = try machine.beginSnapshot()
      let fileVersion = try NSFileVersion.version(withID: snapshot.id, basedOn: paths)
      try fileVersion.remove(with: self.fileManager)
      machine.finishedWithSnapshot(snapshot, by: .remove)
    }

    func syncronizeSnapshots(
      for machine: MachineType,
      options _: SnapshotSyncronizeOptions
    ) async throws -> SnapshotSyncronizationDifference? {
      let paths = try machine.beginSnapshot()
      let versions = NSFileVersion.otherVersionsOfItem(at: paths.snapshottingSourceURL)
      assert(versions != nil)
      guard let versions else {
        return nil
      }
      let snapshotFileDataDictionary: [String: Data]
      let snapshotCollectionDirectoryExists =
        self.fileManager.directoryExists(at: paths.snapshotCollectionURL) == .directoryExists
      if snapshotCollectionDirectoryExists {
        snapshotFileDataDictionary = try self.fileManager.dataDictionary(
          directoryAt: paths.snapshotCollectionURL
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
          Self.logger.error("Unable to fetch persistentIdentifierData: \(error.localizedDescription)")
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
        paths.snapshotCollectionURL.appendingPathComponent(_:)
      )

      try filesToDelete.forEach { url in
        try fileManager.removeItem(at: url)
      }

      let snapshotsAdded = try versionsToAdd.map { versionToAdd in
        try self.saveSnapshot(forVersion: versionToAdd, to: paths.snapshotCollectionURL)
      }

      Self.logger.notice("Updated stored snapshots: -\(filesToDelete.count) +\(snapshotsAdded.count)")

      let snapshotFileURLs = try snapshotCollectionDirectoryExists ?
        FileManager.default.contentsOfDirectory(
          at: paths.snapshotCollectionURL,
          includingPropertiesForKeys: []
        ) : []
      let snapshotIDs = snapshotFileURLs
        .map { $0.deletingPathExtension().lastPathComponent }
        .compactMap(UUID.init(uuidString:))
      assert(snapshotFileURLs.count == snapshotIDs.count)

      return .init(addedSnapshots: snapshotsAdded, snapshotIDs: snapshotIDs)
    }

    func saveSnapshot(
      forVersion version: NSFileVersion,
      to snapshotCollectionURL: URL,
      withRequest request: SnapshotRequest = .init(),
      withID id: UUID = .init()
    ) throws -> Snapshot {
      try self.fileManager.createEmptyDirectory(
        at: snapshotCollectionURL,
        withIntermediateDirectories: false,
        deleteExistingFile: true
      )

      let snapshotFileURL =
        snapshotCollectionURL
          .appendingPathComponent(id.uuidString)
          .appendingPathExtension("bshsnapshot")

      Self.logger.debug("Creating snapshot with id \(id)")

      try version.writePersistentIdentifier(to: snapshotFileURL)

      return Snapshot(
        name: request.name,
        id: id,
        snapshotterID: FileVersionSnapshotterFactory.systemID,
        createdAt: .init(),
        isDiscardable: version.isDiscardable,
        notes: request.notes
      )
    }

    @discardableResult
    func createNewSnapshot(
      of machine: MachineType,
      request: SnapshotRequest,
      options: SnapshotOptions
    ) async throws -> Snapshot {
      let paths = try machine.beginSnapshot()

      let version = try NSFileVersion.addOfItem(
        at: paths.snapshottingSourceURL,
        withContentsOf: paths.snapshottingSourceURL,
        options: options
      )

      let snapshot = try self.saveSnapshot(
        forVersion: version,
        to: paths.snapshotCollectionURL,
        withRequest: request
      )

      machine.finishedWithSnapshot(snapshot, by: .append)
      Self.logger.debug("Completed new snapshot with id \(snapshot.id)")
      return snapshot
    }
  }
#endif
