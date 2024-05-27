//
// DocumentView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import BushelMachineEnvironment
  import SwiftUI

  @MainActor
  internal struct DocumentView: View, Loggable {
    @State var object = DocumentObject()

    @Environment(\.machineSystemManager) var systemManager
    @Environment(\.openWindow) var openWindow
    @Environment(\.database) private var database
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider
    @Environment(\.snapshotProvider) private var snapshotProvider
    @Environment(\.dismiss) private var dismiss
    @Environment(\.databaseChangePublicist) private var databasePublisherFactory

    @Binding var machineFile: MachineFile?

    #warning("What happens when you delete a file")
    #warning("maybe to log changes of onChange")
    #warning("make sure onAppear is printed so we be aware of what the machineFile.url was")
    var body: some View {
      TabView {
        DetailsView(machineObject: object.machineObject)
          .tabItem {
            Label(LocalizedStringID.machineDetailsSystemTab, systemImage: "list.bullet.rectangle.fill")
          }
        #if os(macOS)
          SnapshotsView(url: object.url, machineObject: object.machineObject).tabItem {
            Label(.databaseSnapshots, systemImage: "camera")
          }
        #endif
      }
      .padding()
      .toolbar {
        ToolbarView(
          url: self.object.url,
          canSaveSnapshot: self.object.canSaveSnapshot,
          canStart: self.object.machineObject?.canStart ?? false,
          saveSnapshot: self.object.beginSavingSnapshot
        )
      }
      .focusedSceneValue(\.machineDocument, object)
      // here
      .onChange(of: self.machineFile?.url) {
        self.beginLoadingURL($1)
      }
      // here
      .onAppear {
        self.beginLoadingURL(machineFile?.url)
      }
      .navigationTitle(
        object.title
      )
      .sheet(item: self.$object.currentOperation, content: { (operation: MachineOperation) in
        OperationView(operation: operation)
      })
      .alert(
        isPresented: self.$object.alertIsPresented,
        error: self.object.error
      ) { error in
        if error.isCritical {
          Button("OK") {
            Task { @MainActor in
              self.dismiss()
            }
          }
        }
      } message: { _ in
      }
    }

    func beginLoadingURL(_ url: URL?) {
      self.object
        .beginLoadingURL(
          url,
          withDatabase: database,
          restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
          snapshotFactory: snapshotProvider,
          using: systemManager,
          metadataLabelProvider.callAsFunction(_:_:),
          databasePublisherFactory: self.databasePublisherFactory.callAsFunction(id:)
        )
    }
  }

  #Preview {
    DocumentView(machineFile: .constant(.none))
  }
#endif
