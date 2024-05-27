//
// SnapshotsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  @available(iOS, unavailable)
  internal struct SnapshotsView: View {
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
