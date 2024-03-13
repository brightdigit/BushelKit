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
