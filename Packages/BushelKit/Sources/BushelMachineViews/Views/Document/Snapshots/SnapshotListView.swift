//
// SnapshotListView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelUT
  import SwiftUI

  struct SnapshotListView: View {
    static let snapshotDateFormatter = {
      var formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .medium
      return formatter
    }()

    let url: URL?
    @Bindable var object: MachineObject
    @State private var sortOrder = [
      KeyPathComparator(\Snapshot.createdAt, order: .reverse)
    ]
    @State private var selectedSnapshot: Snapshot.ID?

    var body: some View {
      Table(
        object.machine.configuration.snapshots,
        selection: self.$selectedSnapshot,
        sortOrder: self.$sortOrder
      ) {
        TableColumn("") { snapshot in
          SnapshotActionsView(snapshot: snapshot, agent: self.object)
        }
        TableColumn("Name", value: \.name) { snapshot in
          Text(snapshot.name)
        }
        TableColumn("Date", value: \.createdAt) { snapshot in
          Text(snapshot.createdAt, formatter: Self.snapshotDateFormatter)
        }

        TableColumn("Size", value: \.fileLength) { snapshot in
          Text(
            ByteCountFormatStyle.FormatInput(snapshot.fileLength),
            format: .byteCount(style: .file)
          )
        }
        TableColumn("Notes", value: \.notes).width(ideal: 160, max: 280)
      }

      .fileExporter(
        isPresented: $object.presentExportingSnapshot,
        document: object.exportingSnapshot?.1,
        onCompletion: { result in
          self.object.beginExport(to: result)
        }
      )
      .confirmationDialog(
        "Would you like to take a snapshot of the current state before restoring?",
        isPresented: $object.presentRestoreConfirmation,
        presenting: self.object.confirmingRestoreSnapshot,
        actions: {
          SnapshotRestoreActions(
            url: self.url,
            snapshot: $0,
            agent: self.object
          )
        }
      )
      .confirmationDialog(
        "Delete Snapshot",
        isPresented: $object.presentDeleteConfirmation,
        presenting: self.object.confirmingRemovingSnapshot
      ) {
        SnapshotDeleteActions(
          url: self.url,
          snapshot: $0,
          agent: self.object
        )
      }
    }
  }
#endif
