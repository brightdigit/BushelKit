//
//  FileManager.swift
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
  internal import BushelLogging
  internal import Foundation

  /// Provides a set of file-related utilities for managing a snapshot collection directory.
  extension FileManager {
    /// Processes file updates between a set of versions and the current snapshot collection directory.
    ///
    /// - Parameters:
    ///   - snapshotCollectionURL: The URL of the snapshot collection directory.
    ///   - versions: An array of `NSFileVersion` objects representing the versions to process.
    ///   - logger: A `Logger` instance to use for logging any errors.
    /// - Returns: A `SnapshotFileUpdate` object containing the files to delete and the versions to add.
    internal func fileUpdates(
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
      let dataLookup = Dictionary(grouping: snapshotFileDataDictionary, by: { $0.value }).mapValues
      {
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

    /// Retrieves a list of UUIDs of the files in the snapshot collection directory.
    ///
    /// - Parameter snapshotCollectionURL: The URL of the snapshot collection directory.
    /// - Returns: An array of `UUID` objects
    /// representing the UUIDs of the files in the snapshot collection directory.
    internal func filenameUUIDs(atDirectoryURL snapshotCollectionURL: URL) throws -> [UUID] {
      let snapshotCollectionDirectoryExists =
        self.directoryExists(at: snapshotCollectionURL) == .directoryExists
      let snapshotFileURLs =
        try snapshotCollectionDirectoryExists
        ? self.contentsOfDirectory(
          at: snapshotCollectionURL,
          includingPropertiesForKeys: []
        ) : []
      let snapshotIDs =
        snapshotFileURLs
        .map { $0.deletingPathExtension().lastPathComponent }
        .compactMap(UUID.init(uuidString:))
      assert(snapshotFileURLs.count == snapshotIDs.count)
      return snapshotIDs
    }
  }
#endif
