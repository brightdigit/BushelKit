//
// BindableSnapshotObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI
  @Observable
  class BindableSnapshotObject {
    let snapshot: () async -> Bindable<SnapshotObject>?
    var bindableSnapshot: Bindable<SnapshotObject>?

    internal init(snapshot: @escaping () async -> Bindable<SnapshotObject>?) {
      self.snapshot = snapshot

      Task {
        self.bindableSnapshot = await self.snapshot()
      }
    }
  }

#endif
