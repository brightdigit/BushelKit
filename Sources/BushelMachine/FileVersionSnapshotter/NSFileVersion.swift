//
//  NSFileVersion.swift
//  BushelKit
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

#if !os(Linux)
  import Foundation

  extension NSFileVersion {
    internal struct VersionDataSet {
      internal let fileVersion: NSFileVersion
      internal let url: URL

      internal func remove(with fileManager: FileManager) throws {
        try fileVersion.remove()
        try fileManager.removeItem(at: url)
      }
    }

    internal var persistentIdentifierData: Data {
      get throws {
        try NSKeyedArchiver.archivedData(
          withRootObject: self.persistentIdentifier,
          requiringSecureCoding: false
        )
      }
    }

    @available(iOS, unavailable)
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
      guard let persistentIdentifier =
        unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) else {
        throw SnapshotError.unarchiveError(identifierData)
      }
      guard let version = self.version(itemAt: url, forPersistentIdentifier: persistentIdentifier) else {
        throw SnapshotError.missingSnapshotVersionAt(url)
      }
      return version
    }

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

    internal func writePersistentIdentifier(to snapshotFileURL: URL) throws {
      try persistentIdentifierData.write(to: snapshotFileURL)
    }
  }

  extension NSFileVersion.AddingOptions {
    internal init(options: SnapshotOptions) {
      self = options.contains(.byMoving) ? [.byMoving] : []
    }
  }
#endif
