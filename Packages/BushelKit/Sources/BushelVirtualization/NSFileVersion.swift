//
// NSFileVersion.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if os(macOS)
  extension NSFileVersion: FileVersion {
    public static var typeID: String {
      "NSFileVersion"
    }

    public static func fetchVersion(at url: URL, withID id: Data) throws -> FileVersion? {
      guard let persistentIdentifier = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(id) else {
        throw ManagerError.undefinedType("Invalid ID Format", id)
      }
      return version(itemAt: url, forPersistentIdentifier: persistentIdentifier)
    }

    public static func createVersion(at url: URL, withContentsOf contentsURL: URL, isDiscardable: Bool, byMoving: Bool) throws -> FileVersion {
      let options: AddingOptions = byMoving ? [.byMoving] : []
      let version = try NSFileVersion.addOfItem(at: url, withContentsOf: contentsURL, options: options)
      if isDiscardable {
        version.isDiscardable = true
      }
      return version
    }

    public func save(to url: URL) async throws {
      try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
        do {
          try self.replaceItem(at: url)
        } catch {
          continuation.resume(throwing: error)
          return
        }
        continuation.resume()
      }
    }

    public func getIdentifier() throws -> Data {
      try NSKeyedArchiver.archivedData(
        withRootObject: persistentIdentifier,
        requiringSecureCoding: false
      )
    }
  }
#endif
