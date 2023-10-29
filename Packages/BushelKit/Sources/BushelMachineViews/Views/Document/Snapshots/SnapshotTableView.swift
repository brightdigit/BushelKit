//
// SnapshotTableView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import SwiftUI

  struct SnapshotTableView: View {
    @State private var sortOrder = [
      KeyPathComparator(\Snapshot.createdAt, order: .reverse)
    ]
    @Binding var selectedSnapshot: Snapshot.ID?
    let snapshots: [Snapshot]
    let agent: SnapshotActionsAgent

    var body: some View {
      Table(
        snapshots,
        selection: self.$selectedSnapshot,
        sortOrder: self.$sortOrder
      ) {
        TableColumn("") { snapshot in
          SnapshotActionsView(snapshot: snapshot, agent: self.agent)
        }.width(72)
        TableColumn("Name", value: \.name) { snapshot in
          Text(snapshot.name)
        }.defaultVisibility(.hidden)
        TableColumn("Date", value: \.createdAt) { snapshot in
          Text(snapshot.createdAt, formatter: Formatters.snapshotDateFormatter)
        }

        TableColumn("Size", value: \.fileLength) { snapshot in
          Text(
            ByteCountFormatStyle.FormatInput(snapshot.fileLength),
            format: .byteCount(style: .file)
          )
        }
        TableColumn("Notes", value: \.notes).width(ideal: 160, max: 280).defaultVisibility(.hidden)
      }
    }
  }

//  #Preview {
//    SnapshotTableView()
//  }
#endif
