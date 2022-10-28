//
// NSFileVersion.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

#if os(macOS)
  public extension NSFileVersion {
    func getArchivedPersistentIdentifier() throws -> Data {
      try NSKeyedArchiver.archivedData(
        withRootObject: persistentIdentifier,
        requiringSecureCoding: false
      )
    }
  }
#endif
