//
//  FileVersionSnapshotter.swift
//  Sublimation
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if os(macOS)
  import BushelCore

  public import BushelLogging

  public import Foundation

  public struct FileVersionSnapshotter<MachineType: Machine>: Snapshotter, Loggable {
    public static var loggingCategory: BushelLogging.Category { .machine }

    let fileManager: FileManager

    init(fileManager: FileManager = .default) { self.fileManager = fileManager }

    init(for _: MachineType.Type, fileManager: FileManager = .default) {
      self.init(fileManager: fileManager)
    }

    init(for _: MachineType, fileManager: FileManager = .default) {
      self.init(fileManager: fileManager)
    }

    public func exportSnapshot(_ snapshot: Snapshot, from machine: MachineType, to url: URL)
      async throws
    {
      let paths = try machine.beginSnapshot()
      let fileVersion = try (NSFileVersion.version(withID: snapshot.id, basedOn: paths)).fileVersion
      try fileVersion.replaceItem(at: url)
      let exportedConfiguration = await MachineConfiguration(
        snapshot: snapshot,
        original: machine.updatedConfiguration
      )
      let data = try JSON.encoder.encode(exportedConfiguration)
      let configurationFileURL = url.appendingPathComponent(URL.bushel.paths.machineJSONFileName)
      let newSnapshotsDirURL = url.appending(component: URL.bushel.paths.snapshotsDirectoryName)
      if fileManager.directoryExists(at: newSnapshotsDirURL) == .directoryExists {
        try fileManager.removeItem(at: newSnapshotsDirURL)
      }
      try fileManager.createEmptyDirectory(
        at: newSnapshotsDirURL,
        withIntermediateDirectories: false,
        deleteExistingFile: false
      )
      try data.write(to: configurationFileURL)
      await machine.finishedWithSnapshot(snapshot, by: .export)
    }

    public func restoreSnapshot(_ snapshot: Snapshot, to machine: MachineType) async throws {
      let paths = try machine.beginSnapshot()
      let oldSnapshots = try fileManager.dataDictionary(directoryAt: paths.snapshotCollectionURL)

      let snapshotFileNameKey = [snapshot.id.uuidString, "bshsnapshot"].joined(separator: ".")

      guard let identifierData = oldSnapshots[snapshotFileNameKey] else {
        throw SnapshotError.missingSnapshotFile(snapshot.id)
      }

      Self.logger.debug(
        "Retrieving snapshot \(snapshot.id) for machine at \(paths.snapshottingSourceURL)"
      )
      let fileVersion = try Result {
        try NSFileVersion.version(
          itemAt: paths.snapshottingSourceURL,
          forPersistentIdentifierData: identifierData
        )
      }
      .mapError(SnapshotError.inner(error:))
      .unwrap(or: SnapshotError.missingSnapshotVersionID(snapshot.id)).get()

      do {
        Self.logger.debug(
          "Replacing with snapshot \(snapshot.id) for machine at \(paths.snapshottingSourceURL)"
        )
        try fileVersion.replaceItem(at: paths.snapshottingSourceURL)
        try fileManager.write(oldSnapshots, to: paths.snapshotCollectionURL)
      }
      catch { throw SnapshotError.inner(error: error) }
      await machine.finishedWithSnapshot(snapshot, by: .restored)
    }

    public func deleteSnapshot(_ snapshot: Snapshot, from machine: MachineType) async throws {
      let paths = try machine.beginSnapshot()
      let fileVersion = try NSFileVersion.version(withID: snapshot.id, basedOn: paths)
      try fileVersion.remove(with: fileManager)
      await machine.finishedWithSnapshot(snapshot, by: .remove)
    }

    public func saveSnapshot(
      forVersion version: NSFileVersion,
      to snapshotCollectionURL: URL,
      withRequest request: SnapshotRequest = .init(),
      withID id: UUID = .init()
    ) throws -> Snapshot {
      try fileManager.createEmptyDirectory(
        at: snapshotCollectionURL,
        withIntermediateDirectories: false,
        deleteExistingFile: true
      )

      let snapshotFileURL = snapshotCollectionURL.appendingPathComponent(id.uuidString)
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

    @discardableResult public func createNewSnapshot(
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

      let snapshot = try saveSnapshot(
        forVersion: version,
        to: paths.snapshotCollectionURL,
        withRequest: request
      )

      await machine.finishedWithSnapshot(snapshot, by: .append)
      Self.logger.debug("Completed new snapshot with id \(snapshot.id)")
      return snapshot
    }
  }
#endif
