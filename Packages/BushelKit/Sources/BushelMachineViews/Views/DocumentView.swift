//
// DocumentView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
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
    @Binding var machineFile: MachineFile?
    var body: some View {
      TabView {
        HStack {
          Image(icon: Icons.Machine.desktop01).resizable().aspectRatio(contentMode: .fit).padding(80.0)
          GeometryReader { proxy in
            Group {
              if let machineObject = object.machineObject {
                SpecificationsView(
                  label: machineObject.label,
                  configuration: machineObject.machine.configuration
                )
              }
              //                MachineSpecListView(
              //                  specification: document.machine.specification,
              //                  operatingSystem: operatingSystem,
              //                  previewImageManager: nil
              //                )
            }
            .frame(
              minWidth: proxy.size.width / 2.0,
              minHeight: proxy.size.height,
              alignment: .center
            )
          }
        }.tabItem {
          Label(LocalizedStringID.machineDetailsSystemTab, systemImage: "list.bullet.rectangle.fill")
        }
        //        SnapshotListView(
        //                    document: self.$document,
        //          snapshots: document.machine.snapshots).tabItem {
        //          Label("Snapshots", image: "camera")
        //        }
      }
      .padding()
      .toolbar {
        ToolbarItemGroup {
          Button {
            do {
              if object.machineObject != nil {
                // try machineObject.addSnapshot()
                throw NSError()
              }
            } catch {
              Self.logger.error("couldn't take a snapshot: \(error.localizedDescription)")
            }
          } label: {
            Image(systemName: "camera")
            Text(.snapshotMachine)
          }
          Button {
            if let url = object.url {
              openWindow(value: SessionRequest(url: url))
            }
          } label: {
            Image(systemName: "play")
            Text(.startMachine)
          }
        }
      }
      .onChange(of: self.machineFile?.url) { _, newValue in
        guard let newValue else {
          return
        }
        self.object
          .loadURL(
            newValue,
            withContext: context,
            restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
            using: systemManager,
            metadataLabelProvider.callAsFunction(_:_:)
          )
      }
      .onAppear {
        guard let url = self.machineFile?.url else {
          return
        }
        self.object.loadURL(
          url,
          withContext: context,
          restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
          using: systemManager,
          metadataLabelProvider.callAsFunction(_:_:)
        )
      }
      .navigationTitle(
        object.machineObject?.entry.name ??
          object.url?
          .deletingPathExtension()
          .lastPathComponent ??
          "Loading Machine..."
      )
    }
  }

  #Preview {
    DocumentView(machineFile: .constant(.none))
  }
#endif
