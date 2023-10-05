//
// SnapshotsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct SnapshotsView: View {
    let url: URL?
    var machineObject: MachineObject?
    var body: some View {
      Group {
        if let machineObject {
          SnapshotListView(
            url: url,
            object: machineObject
          )
        } else {
          ProgressView()
        }
      }
    }
  }

#endif
