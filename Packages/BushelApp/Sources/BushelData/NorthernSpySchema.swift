//
// NorthernSpySchema.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import SwiftData

  public enum NorthernSpySchema: VersionedSchema {
    public static var models: [any PersistentModel.Type] {
      .all
    }

    public static var versionIdentifier: Schema.Version {
      Schema.Version(1, 0, 0)
    }
  }

  extension Array where Element == any PersistentModel.Type {
    fileprivate static var all: [any PersistentModel.Type] {
      [core, library, .machine].flatMap { $0 }
    }
  }
#endif
