//
// MigrationPlan.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import SwiftData

  public enum MigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
      [NorthernSpySchema.self]
    }

    public static var stages: [MigrationStage] {
      []
    }
  }
#endif
