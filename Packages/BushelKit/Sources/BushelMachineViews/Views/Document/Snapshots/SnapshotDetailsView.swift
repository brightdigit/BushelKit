//
// SnapshotDetailsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct SnapshotDetailsView: View {
    var snapshot: Bindable<SnapshotObject>?
    let saveAction: (SnapshotObject) -> Void

    internal init(snapshot: Bindable<SnapshotObject>?,
                  saveAction: @escaping (SnapshotObject) -> Void) {
      self.snapshot = snapshot
      self.saveAction = saveAction
    }

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
  }

//  #Preview {
//    SnapshotDetailsView()
//  }
#endif
