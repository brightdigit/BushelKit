//
// SnapshotRestoreActions.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import BushelMachine
  import SwiftUI

  struct SnapshotRestoreActions: View, Loggable {
    let url: URL?
    let snapshot: Snapshot
    let restore: (Snapshot, URL, SnapshotRequest?) -> Void
    let cancel: (Snapshot) -> Void

    var body: some View {
      Button {
        guard let url = self.url else {
          assertionFailure("Missing url for restore snapshot operation.")
          Self.logger.critical("Missing url for restore snapshot operation.")
          return
        }
        self.restore(snapshot, url, .init())
      } label: {
        Text(.machineConfirmRestoreNew)
      }
      Button {
        guard let url = self.url else {
          assertionFailure("Missing url for restore snapshot operation.")
          Self.logger.critical("Missing url for restore snapshot operation.")
          return
        }
        self.restore(snapshot, url, nil)
      } label: {
        Text(.machineConfirmRestoreOverwrite)
      }
      Button(
        role: .cancel,
        action: {
          self.cancel(snapshot)
        }, label: {
          Text(.machineConfirmRestoreCancel)
        }
      )
    }

    internal init(
      url: URL?,
      snapshot: Snapshot,
      agent: SnapshotRestoreActionsAgent
    ) {
      self.init(
        url: url,
        snapshot: snapshot,
        restore: agent.beginRestoreSnapshot(_:at:takeCurrentSnapshot:),
        cancel: agent.cancelRestoreSnapshot(_:)
      )
    }

    internal init(
      url: URL?,
      snapshot: Snapshot,
      restore: @escaping (Snapshot, URL, SnapshotRequest?) -> Void,
      cancel: @escaping (Snapshot) -> Void
    ) {
      assert(url != nil)
      self.url = url
      self.snapshot = snapshot
      self.restore = restore
      self.cancel = cancel
    }
  }
#endif
