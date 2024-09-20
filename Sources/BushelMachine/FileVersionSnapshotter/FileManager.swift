//
//  FileManager.swift
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
        directoryExists(at: snapshotCollectionURL) == .directoryExists
      if snapshotCollectionDirectoryExists {
        snapshotFileDataDictionary = try dataDictionary(directoryAt: snapshotCollectionURL)
      }
      else {
        snapshotFileDataDictionary = [:]
      }
      let dataLookup = Dictionary(grouping: snapshotFileDataDictionary, by: { $0.value })
        .mapValues { $0.map(\.key) }

      var filesToKeep = [String]()
      var versionsToAdd = [NSFileVersion]()

      for version in versions {
        let persistentIdentifierData: Data
        do { persistentIdentifierData = try version.persistentIdentifierData }
        catch {
          logger.error("Unable to fetch persistentIdentifierData: \(error.localizedDescription)")
          continue
        }

        let files = dataLookup[persistentIdentifierData]
        if let fileToKeep = files?.first {
          filesToKeep.append(fileToKeep)
        }
        else {
          versionsToAdd.append(version)
        }
      }

      let filesToDelete = Set(snapshotFileDataDictionary.keys).subtracting(filesToKeep)
        .map(snapshotCollectionURL.appendingPathComponent(_:))

      return SnapshotFileUpdate(filesToDelete: filesToDelete, versionsToAdd: versionsToAdd)
    }

    func filenameUUIDs(atDirectoryURL snapshotCollectionURL: URL) throws -> [UUID] {
      let snapshotCollectionDirectoryExists =
        directoryExists(at: snapshotCollectionURL) == .directoryExists
      let snapshotFileURLs =
        try snapshotCollectionDirectoryExists
        ? contentsOfDirectory(at: snapshotCollectionURL, includingPropertiesForKeys: []) : []
      let snapshotIDs = snapshotFileURLs.map { $0.deletingPathExtension().lastPathComponent }
        .compactMap(UUID.init(uuidString:))
      assert(snapshotFileURLs.count == snapshotIDs.count)
      return snapshotIDs
    }
  }
#endif
