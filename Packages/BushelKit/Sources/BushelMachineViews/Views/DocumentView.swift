//
// DocumentView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import BushelMachine
  import SwiftUI

  struct DocumentView: View {
    @State var object = DocumentObject()
    @Environment(\.machineSystemManager) var systemManager
    @Environment(\.openWindow) var openWindow
    @Environment(\.modelContext) private var context
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider
    @Binding var machineFile: MachineFile?
    var body: some View {
      Button("start machine") {
        if let url = object.url {
          openWindow(value: SessionRequest(url: url))
        }
      }
      .onChange(of: self.machineFile?.url) { _, newValue in
        guard let newValue else {
          return
        }
        self.object.loadURL(newValue, withContext: context, restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:), using: systemManager, metadataLabelProvider.callAsFunction(_:_:))
      }.onAppear {
        guard let url = self.machineFile?.url else {
          return
        }
        self.object.loadURL(url, withContext: context, restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:), using: systemManager, metadataLabelProvider.callAsFunction(_:_:))
      }.navigationTitle(object.machineObject?.entry.name ?? object.url?.deletingPathExtension().lastPathComponent ?? "Loading Machine...")
    }
  }

  #Preview {
    DocumentView(machineFile: .constant(.none))
  }
#endif
