//
// SnapshotListView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelMachineData
  import BushelMarketEnvironment
  import BushelUT
  import StoreKit
  import SwiftData
  import SwiftUI

  @MainActor
  @available(iOS, unavailable)
  internal struct SnapshotListView: View {
    let url: URL?
    // @Query private var snapshots: [SnapshotEntry]
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider

    @Environment(\.marketplace) private var marketplace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.purchaseWindow) private var purchaseWindow
    @Environment(\.requestReview) var requestReview
    @Bindable var object: MachineObject

    #warning("Add filter for discardable")
    var body: some View {
      GeometryReader { geometry in
        HSplitView {
          Group {
            if let snapshots = object.latestSnapshots {
              SnapshotTableView(
                selectedSnapshot: self.$object.selectedSnapshot,
                snapshots: snapshots,
                agent: self.object
              )
            } else {
              ProgressView()
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          SnapshotDetailsView {
            await self.object.bindableSnapshot(
              usingLabelFrom: self.metadataLabelProvider.callAsFunction(_:_:),
              fromConfigurationURL: self.url
            )
          } save: { snapshotObject in
            self.object.beginSavingSnapshot(snapshotObject)
          }
          .padding()
          .frame(
            minWidth: 256,
            idealWidth: 256,
            maxWidth: min(MachineScene.minimumWidth, geometry.size.width / 2.0),
            maxHeight: .infinity
          )
        }.frame(width: geometry.size.width, height: geometry.size.height)
      }
      .onChange(of: object.currentOperation) { oldValue, newValue in
        guard oldValue != nil, newValue == nil, object.error == nil else {
          return
        }
        Task {
          // Delay for two seconds to avoid interrupting the person using the app.
          try await Task.sleep(for: .seconds(2))
          requestReview()
        }
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

    internal init(
      url: URL?,
      object: MachineObject
    ) {
      self.url = url
      self.object = object
    }
  }
#endif
