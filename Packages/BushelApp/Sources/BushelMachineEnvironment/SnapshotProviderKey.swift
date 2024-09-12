//
// SnapshotProviderKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore

  public import BushelMachine
  import Foundation
  import SwiftData

  public import SwiftUI

  private struct SnapshotProviderKey: EnvironmentKey {
    static let defaultValue: any SnapshotProvider =
      SnapshotterRepository()
  }

  extension EnvironmentValues {
    public var snapshotProvider: any SnapshotProvider {
      get { self[SnapshotProviderKey.self] }
      set { self[SnapshotProviderKey.self] = newValue }
    }
  }

  extension Scene {
    public func snapshotProvider(
      _ snapshotProvider: any SnapshotProvider
    ) -> some Scene {
      self.environment(\.snapshotProvider, snapshotProvider)
    }

    public func snapshotProvider(
      _ factories: [any SnapshotterFactory]
    ) -> some Scene {
      self.snapshotProvider(SnapshotterRepository(factories: factories))
    }
  }
#endif
