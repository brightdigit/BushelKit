//
// DocumentView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import BushelMachineEnvironment
  import SwiftUI

  struct DocumentView: View, LoggerCategorized {
    @State var object = DocumentObject()

    @Environment(\.machineSystemManager) var systemManager
    @Environment(\.openWindow) var openWindow
    @Environment(\.modelContext) private var context
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider
    @Environment(\.snapshotProvider) private var snapshotProvider

    @Binding var machineFile: MachineFile?

    var body: some View {
      TabView {
        DetailsView(machineObject: object.machineObject)
          .tabItem {
            Label(LocalizedStringID.machineDetailsSystemTab, systemImage: "list.bullet.rectangle.fill")
          }
        SnapshotsView(url: object.url, machineObject: object.machineObject).tabItem {
          Label("Snapshots", image: "camera")
        }
      }
      .padding()
      .toolbar {
        ToolbarView(
          url: self.object.url,
          canSaveSnapshot: self.object.canSaveSnapshot,
          saveSnapshot: self.object.beginSavingSnapshot
        )
      }
      .onChange(of: self.machineFile?.url) {
        self.beginLoadingURL($1)
      }
      .onAppear {
        self.beginLoadingURL(machineFile?.url)
      }
      .navigationTitle(
        object.title
      )
      .sheet(item: self.$object.currentOperation, content: { (operation: MachineOperation) in
        OperationView(operation: operation)
      })
    }

    func beginLoadingURL(_ url: URL?) {
      self.object
        .beginLoadingURL(
          url,
          withContext: context,
          restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
          snapshotFactory: snapshotProvider,
          using: systemManager,
          metadataLabelProvider.callAsFunction(_:_:)
        )
    }
  }

  #Preview {
    DocumentView(machineFile: .constant(.none))
  }
#endif
