//
// BindableSnapshotObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  @Observable
  final class BindableSnapshotObject: Sendable {
    let snapshot: @Sendable () async -> Bindable<SnapshotObject>?
    var bindableSnapshot: Bindable<SnapshotObject>?

    internal init(snapshot: @escaping @Sendable () async -> Bindable<SnapshotObject>?) {
      self.snapshot = snapshot

      Task {
        self.bindableSnapshot = await self.snapshot()
      }
    }
  }

#endif
