//
// SnapshotDetailsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct SnapshotDetailsView: View {
    var snapshot: Bindable<SnapshotObject>?
    let saveAction: (SnapshotObject) -> Void

    var body: some View {
      Group {
        if let snapshot {
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
      snapshot: Bindable<SnapshotObject>?,
      saveAction: @escaping (SnapshotObject) -> Void
    ) {
      self.snapshot = snapshot
      self.saveAction = saveAction
    }
  }

//  #Preview {
//    SnapshotDetailsView()
//  }
#endif
