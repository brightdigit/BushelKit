//
// FileVersionSnapshotter.swift
// Copyright (c) 2023 BrightDigit.
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
      let paths = machine.beginSnapshot()
      let fileVersion = try NSFileVersion.version(withID: snapshot.id, basedOn: paths)
      try fileVersion.replaceItem(at: url)
      let exportedConfiguration = MachineConfiguration(snapshot: snapshot, original: machine.configuration)
      let data = try JSON.encoder.encode(exportedConfiguration)
      let configurationFileURL = url.appendingPathComponent(URL.bushel.paths.machineJSONFileName)
      let newSnapshotsDirURL = url.appending(component: URL.bushel.paths.snapshotsDirectoryName)
      try self.fileManager.removeItem(at: newSnapshotsDirURL)
      try self.fileManager.createEmptyDirectory(
        at: newSnapshotsDirURL,
        withIntermediateDirectories: false,
        deleteExistingFile: false
      )
      try data.write(to: configurationFileURL)
      machine.finishedWithSnapshot(snapshot, by: .export)
    }

    func restoreSnapshot(_ snapshot: Snapshot, to machine: MachineType) throws {
      let paths = machine.beginSnapshot()
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
      let paths = machine.beginSnapshot()
      let fileVersion = try NSFileVersion.version(withID: snapshot.id, basedOn: paths)
      try fileVersion.remove()
      machine.finishedWithSnapshot(snapshot, by: .remove)
    }

    @discardableResult
    func createNewSnapshot(
      of machine: MachineType,
      request: SnapshotRequest,
      options: SnapshotOptions
    ) async throws -> Snapshot {
      let id = UUID()

      let paths = machine.beginSnapshot()

      try self.fileManager.createEmptyDirectory(
        at: paths.snapshotCollectionURL,
        withIntermediateDirectories: false,
        deleteExistingFile: true
      )

      let snapshotFileURL =
        paths.snapshotCollectionURL
          .appendingPathComponent(id.uuidString)
          .appendingPathExtension("bshsnapshot")

      Self.logger.debug("Creating snapshot with id \(id)")
      let version = try NSFileVersion.addOfItem(
        at: paths.snapshottingSourceURL,
        withContentsOf: paths.snapshottingSourceURL,
        options: options
      )

      try version.writePersistentIdentifier(to: snapshotFileURL)

      let snapshot = Snapshot(
        name: request.name,
        id: id,
        snapshotterID: FileVersionSnapshotterFactory.systemID,
        createdAt: .init(),
        isDiscardable: version.isDiscardable,
        notes: request.notes
      )

      machine.finishedWithSnapshot(snapshot, by: .append)
      Self.logger.debug("Completed new snapshot with id \(id)")
      return snapshot
    }
  }
#endif
