//
// SnapshotListView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelMarketEnvironment
  import BushelUT
  import SwiftUI

  @available(iOS, unavailable)
  struct SnapshotListView: View {
    let url: URL?
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider
    @Environment(\.marketplace) private var marketplace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.purchaseWindow) private var purchaseWindow
    @Bindable var object: MachineObject

    #warning("Use query to stay in sync")
    #warning("Add filter for discardable")
    var body: some View {
      GeometryReader { geometry in
        HSplitView {
          SnapshotTableView(
            selectedSnapshot: self.$object.selectedSnapshot,
            snapshots: object.machine.configuration.snapshots,
            agent: self.object
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          SnapshotDetailsView(
            snapshot:
            self.object.bindableSnapshot(
              usingLabelFrom: self.metadataLabelProvider.callAsFunction(_:_:),
              fromConfigurationURL: self.url
            ),
            saveAction: self.object.beginSavingSnapshot
          )
          .padding()
          .frame(
            minWidth: 256,
            idealWidth: 256,
            maxWidth: min(MachineScene.minimumWidth, geometry.size.width / 2.0),
            maxHeight: .infinity
          )
        }.frame(width: geometry.size.width, height: geometry.size.height)
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
