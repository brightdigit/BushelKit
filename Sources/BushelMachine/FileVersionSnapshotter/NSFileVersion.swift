//
//  NSFileVersion.swift
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

#if !os(Linux)

  internal import Foundation

  extension NSFileVersion {
    /// An internal struct representing a set of version data.
    internal struct VersionDataSet {
      /// The file version.
      internal let fileVersion: NSFileVersion
      /// The URL of the file version.
      internal let url: URL

      /// Removes the file version and its associated URL.
      /// - Parameter fileManager: The file manager to use for removal.
      /// - Throws: Any errors that occur during the removal process.
      internal func remove(with fileManager: FileManager) throws {
        try self.fileVersion.remove()
        try fileManager.removeItem(at: self.url)
      }
    }

    /// The persistent identifier data for the file version.
    internal var persistentIdentifierData: Data {
      get throws {
        try NSKeyedArchiver.archivedData(
          withRootObject: self.persistentIdentifier,
          requiringSecureCoding: false
        )
      }
    }

    /// Adds a new file version at the specified URL with the contents from the provided URL.
    /// - Parameters:
    ///   - url: The URL of the file to add the version for.
    ///   - contentsURL: The URL of the file contents to use for the new version.
    ///   - options: The snapshot options to use for the new version.
    /// - Returns: The newly added file version.
    /// - Throws: Any errors that occur during the file version addition process.
    @available(iOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    internal static func addOfItem(
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

    /// Retrieves the file version for the item at the specified URL
    /// using the provided persistent identifier data.
    /// - Parameters:
    ///   - url: The URL of the file to get the version for.
    ///   - identifierData: The persistent identifier data for the version.
    /// - Returns: The file version.
    /// - Throws: Any errors that occur during the version retrieval process.
    internal static func version(
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
      guard
        let persistentIdentifier = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey)
      else {
        throw SnapshotError.unarchiveError(identifierData)
      }
      guard let version = self.version(itemAt: url, forPersistentIdentifier: persistentIdentifier)
      else {
        throw SnapshotError.missingSnapshotVersionAt(url)
      }
      return version
    }

    /// Retrieves a version data set for the file version
    /// with the specified snapshot ID based on the provided snapshot paths.
    /// - Parameters:
    ///   - snapshotID: The UUID of the snapshot to retrieve the version data set for.
    ///   - paths: The snapshot paths to use for the version data set retrieval.
    /// - Returns: The version data set.
    /// - Throws: Any errors that occur during the version data set retrieval process.
    internal static func version(
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

    /// Writes the persistent identifier to the specified snapshot file URL.
    /// - Parameter snapshotFileURL: The URL of the snapshot file to write the persistent identifier to.
    /// - Throws: Any errors that occur during the write process.
    internal func writePersistentIdentifier(to snapshotFileURL: URL) throws {
      try self.persistentIdentifierData.write(to: snapshotFileURL)
    }
  }

  extension NSFileVersion.AddingOptions {
    /// Initializes the adding options based on the provided snapshot options.
    /// - Parameter options: The snapshot options to use for initialization.
    internal init(options: SnapshotOptions) {
      self = options.contains(.byMoving) ? [.byMoving] : []
    }
  }
#endif
