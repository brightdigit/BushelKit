//
// SnapshotDeleteActions.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import BushelMachine
  import SwiftUI

  struct SnapshotDeleteActions: View, Loggable {
    let url: URL?
    let snapshot: Snapshot
    let delete: (Snapshot?, URL?) -> Void
    let cancel: (Snapshot?) -> Void

    var body: some View {
      Button(
        role: .destructive
      ) {
        guard let url = self.url else {
          assertionFailure("Missing url for delete snapshot operation.")
          Self.logger.critical("Missing url for delete snapshot operation.")
          return
        }
        self.delete(snapshot, url)
      } label: {
        Text(.machineConfirmDeleteYes)
      }
      Button(
        role: .cancel,
        action: {
          self.cancel(snapshot)
        },
        label: {
          Text(.machineConfirmDeleteCancel)
        }
      )
    }

    internal init(
      url: URL?,
      snapshot: Snapshot,
      delete: @escaping (Snapshot?, URL?) -> Void,
      cancel: @escaping (Snapshot?) -> Void
    ) {
      self.url = url
      self.snapshot = snapshot
      self.delete = delete
      self.cancel = cancel
    }

    internal init(url: URL?, snapshot: Snapshot, agent: SnapshotDeleteActionsAgent) {
      self.init(
        url: url,
        snapshot: snapshot,
        delete: agent.deleteSnapshot(_:at:),
        cancel: agent.cancelDeleteSnapshot(_:)
      )
    }
  }
#endif
