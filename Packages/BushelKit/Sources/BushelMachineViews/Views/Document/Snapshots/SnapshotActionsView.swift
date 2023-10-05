//
// SnapshotActionsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct SnapshotActionsView: View {
    internal init(
      snapshot: Snapshot,
      deleting: @escaping (Snapshot) -> Void,
      exporting: @escaping (Snapshot) -> Void,
      restoring: @escaping (Snapshot) -> Void
    ) {
      self.snapshot = snapshot
      self.deleting = deleting
      self.exporting = exporting
      self.restoring = restoring
    }

    internal init(
      snapshot: Snapshot,
      agent: SnapshotActionsAgent
    ) {
      self.init(
        snapshot: snapshot,
        deleting: agent.queueDeletingSnapshot(_:),
        exporting: agent.queueExportingSnapshot(_:),
        restoring: agent.queueRestoringSnapshot(_:)
      )
    }

    let snapshot: Snapshot
    let deleting: (Snapshot) -> Void
    let exporting: (Snapshot) -> Void
    let restoring: (Snapshot) -> Void

    var body: some View {
      HStack {
        Button {
          exporting(snapshot)
        } label: {
          Image(systemName: "square.and.arrow.up.fill")
        }
        Button {
          restoring(snapshot)
        } label: {
          Image(systemName: "arrow.uturn.backward")
        }
        Button {
          deleting(snapshot)
        } label: {
          Image(systemName: "trash.fill")
        }
      }
    }
  }
#endif
