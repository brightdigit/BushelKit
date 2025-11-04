//
//  FileVersionSnapshotter.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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
  internal import BushelFoundation
  public import BushelLogging
  internal import BushelUtilities
  public import Foundation

  // swiftlint:disable file_length

  /// A structure that provides a `Snapshotter` and `Loggable` implementation
  /// for managing file versions as snapshots.
  public struct FileVersionSnapshotter<MachineType: Machine>: Snapshotter, Loggable {
    /// The logging category for this type.
    public static var loggingCategory: BushelLogging.Category {
      .machine
    }

    internal let fileManager: FileManager

    /// Initializes a `FileVersionSnapshotter` with the provided `FileManager`.
    internal init(fileManager: FileManager = .default) {
      self.fileManager = fileManager
    }

    /// Initializes a `FileVersionSnapshotter`
    /// for the specified `MachineType` with the provided `FileManager`.
    internal init(for _: MachineType.Type, fileManager: FileManager = .default) {
      self.init(fileManager: fileManager)
    }

    /// Initializes a `FileVersionSnapshotter`
    /// for the specified `MachineType` with the provided `FileManager`.
    internal init(for _: MachineType, fileManager: FileManager = .default) {
      self.init(fileManager: fileManager)
    }

    /// Exports a snapshot to the specified URL.
    ///
    /// - Parameters:
    ///   - snapshot: The snapshot to export.
    ///   - machine: The machine from which the snapshot is being exported.
    ///   - url: The URL to export the snapshot to.
    /// - Throws: Any errors that may occur during the export process.
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
      let newSnapshotsDirURL: URL

      if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
        newSnapshotsDirURL = url.appending(component: URL.bushel.paths.snapshotsDirectoryName)
      } else {
        newSnapshotsDirURL = url.appendingPathComponent(
          URL.bushel.paths.snapshotsDirectoryName,
          conformingTo: .directory
        )
      }
      if self.fileManager.directoryExists(at: newSnapshotsDirURL) == .directoryExists {
        try self.fileManager.removeItem(at: newSnapshotsDirURL)
      }
      try self.fileManager.createEmptyDirectory(
        at: newSnapshotsDirURL,
        withIntermediateDirectories: false,
        deleteExistingFile: false
      )
      try data.write(to: configurationFileURL)
      await machine.finishedWithSnapshot(snapshot, by: .export)
    }

    /// Restores a snapshot to the specified machine.
    ///
    /// - Parameters:
    ///   - snapshot: The snapshot to restore.
    ///   - machine: The machine to restore the snapshot to.
    /// - Throws: Any errors that may occur during the restore process.
    public func restoreSnapshot(_ snapshot: Snapshot, to machine: MachineType) async throws {
      let paths = try machine.beginSnapshot()
      let oldSnapshots = try self.fileManager.dataDictionary(
        directoryAt: paths.snapshotCollectionURL
      )

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
      await machine.finishedWithSnapshot(snapshot, by: .restored)
    }

    /// Deletes a snapshot from the specified machine.
    ///
    /// - Parameters:
    ///   - snapshot: The snapshot to delete.
    ///   - machine: The machine from which the snapshot is being deleted.
    /// - Throws: Any errors that may occur during the deletion process.
    public func deleteSnapshot(_ snapshot: Snapshot, from machine: MachineType) async throws {
      let paths = try machine.beginSnapshot()
      let fileVersion = try NSFileVersion.version(withID: snapshot.id, basedOn: paths)
      try fileVersion.remove(with: self.fileManager)
      await machine.finishedWithSnapshot(snapshot, by: .remove)
    }

    /// Saves a snapshot for the specified file version.
    ///
    /// - Parameters:
    ///   - version: The file version to save as a snapshot.
    ///   - snapshotCollectionURL: The URL for the collection of snapshots.
    ///   - request: The snapshot request containing the name and notes for the snapshot.
    ///   - id: The unique identifier for the snapshot.
    /// - Returns: The created snapshot.
    /// - Throws: Any errors that may occur during the save process.
    public func saveSnapshot(
      forVersion version: NSFileVersion,
      to snapshotCollectionURL: URL,
      withRequest request: SnapshotRequest = .init(),
      withID id: UUID = .init(),
      image: RecordedImage? = nil
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
        notes: request.notes,
        image: image
      )
    }

    /// Creates a new snapshot for the specified machine.
    ///
    /// - Parameters:
    ///   - machine: The machine to create the snapshot for.
    ///   - request: The snapshot request containing the name and notes for the snapshot.
    ///   - options: The options to use when creating the snapshot.
    /// - Returns: The created snapshot.
    /// - Throws: Any errors that may occur during the snapshot creation process.
    @discardableResult
    public func createNewSnapshot(
      of machine: MachineType,
      request: SnapshotRequest,
      options: SnapshotOptions,
      image: RecordedImage?
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
        withRequest: request,
        image: image
      )

      await machine.finishedWithSnapshot(snapshot, by: .append)
      Self.logger.debug("Completed new snapshot with id \(snapshot.id)")
      return snapshot
    }
  }
#endif
