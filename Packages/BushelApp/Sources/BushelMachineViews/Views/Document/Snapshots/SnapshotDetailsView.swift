//
// SnapshotDetailsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  @MainActor
  internal struct SnapshotDetailsView: View {
    var bindableSnapshotObject: BindableSnapshotObject
    let saveAction: (SnapshotObject) -> Void

    var body: some View {
      Group {
        if let snapshot = bindableSnapshotObject.bindableSnapshot {
          SnapshotView(
            snapshot: snapshot,
            saveAction: saveAction
          )
        } else {
          EmptyView()
        }
      }
    }

    internal init(
      snapshot: @Sendable @escaping () async -> Bindable<SnapshotObject>?,
      save: @escaping (SnapshotObject) -> Void
    ) {
      self.bindableSnapshotObject = .init(snapshot: snapshot)
      self.saveAction = save
    }
  }

#endif
