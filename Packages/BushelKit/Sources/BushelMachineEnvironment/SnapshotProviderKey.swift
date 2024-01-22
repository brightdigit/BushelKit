//
// SnapshotProviderKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  private struct SnapshotProviderKey: EnvironmentKey {
    static let defaultValue: any SnapshotProvider =
      SnapshotterRepository()
  }

  public extension EnvironmentValues {
    var snapshotProvider: any SnapshotProvider {
      get { self[SnapshotProviderKey.self] }
      set { self[SnapshotProviderKey.self] = newValue }
    }
  }

  public extension Scene {
    func snapshotProvider(
      _ snapshotProvider: any SnapshotProvider
    ) -> some Scene {
      self.environment(\.snapshotProvider, snapshotProvider)
    }

    func snapshotProvider(
      _ factories: [any SnapshotterFactory]
    ) -> some Scene {
      self.snapshotProvider(SnapshotterRepository(factories: factories))
    }
  }
#endif
