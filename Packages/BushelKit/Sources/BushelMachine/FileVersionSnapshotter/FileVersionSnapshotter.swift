//
// FileVersionSnapshotter.swift
// Copyright (c) 2023 BrightDigit.
//

#if os(macOS)
  import BushelCore
  import Foundation

  struct FileVersionSnapshotter<MachineType: Machine>: Snapshotter {
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

    #warning("logging-note: any useful logging here")
    func exportSnapshot(_ snapshot: Snapshot, from machine: MachineType, to url: URL) throws {
      let paths = machine.beginSnapshot()
      let fileVersion = try NSFileVersion.version(withID: snapshot.id, basedOn: paths)
      try fileVersion.replaceItem(at: url)
      let exportedConfiguration = MachineConfiguration(snapshot: snapshot, original: machine.configuration)
      let data = try JSON.encoder.encode(exportedConfiguration)
      let configurationFileURL = url.appendingPathComponent(Paths.machineJSONFileName)
      let newSnapshotsDirURL = url.appending(component: Paths.snapshotsDirectoryName)
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

    #warning("logging-note: I think we should log every step here")
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

      let version = try NSFileVersion.addOfItem(
        at: paths.snapshottingSourceURL,
        withContentsOf: paths.snapshottingSourceURL,
        options: .init(options: options)
      )

      if options.contains(.discardable) {
        version.isDiscardable = true
      }

      let contentLength = try await self.fileManager.accumulateSizeFromDirectory(at: version.url)

      let persistentIdentifierData = try NSKeyedArchiver.archivedData(
        withRootObject: version.persistentIdentifier,
        requiringSecureCoding: false
      )

      try persistentIdentifierData.write(to: snapshotFileURL)

      let snapshot = Snapshot(
        name: request.name,
        id: id,
        snapshotterID: FileVersionSnapshotterFactory.systemID,
        createdAt: .init(),
        fileLength: contentLength,
        isDiscardable: version.isDiscardable,
        notes: request.notes
      )
      machine.finishedWithSnapshot(snapshot, by: .append)

      return snapshot
    }
  }
#endif
