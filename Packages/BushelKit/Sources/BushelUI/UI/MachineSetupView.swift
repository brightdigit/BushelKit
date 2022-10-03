//
// MachineSetupView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineSetupView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    @State var machineRestoreImage: MachineRestoreImage?
    @State var showSaveProgress = false
    @State var isReadyToSave = false
    @State var machineSavedURL: URL?
    @Binding var document: MachineDocument
    let url: URL?
    let restoreImageChoices: [MachineRestoreImage]
    @StateObject var installationObject = MachineInstallationObject()

    let onCompleted: ((Error?) -> Void)?

    var body: some View {
      VStack {
        if document.machine.operatingSystem == nil {
          Picker("Restore Image", selection: self.$machineRestoreImage) {
            ForEach(restoreImageChoices) { choice in
              Text(choice.name).tag(choice as MachineRestoreImage?)
            }
          }.padding()
        }
        HStack {
          Button {
            dismiss()
          } label: {
            Text(.cancel)
          }
          Button {
            Task {
              let factory: VirtualMachineFactory
              do {
                factory = try await document.machine.build()
              } catch {
                dump(error)
                return
              }
              installationObject.setupInstaller(factory)
              factory.beginBuild()
            }
          } label: {
            Text(.buildMachine)
          }
        }
      }.onReceive(self.installationObject.$phaseProgress, perform: { phase in
        guard case let .completed(result) = phase?.phase else {
          return
        }
        switch result {
        case let .success(machineConfigurationURL):
          DispatchQueue.main.async {
            self.document.machine.installationCompletedAt(machineConfigurationURL)
          }

        case let .failure(error):
          self.onCompleted?(error)
        }
        self.installationObject.cancel()
      })
      .fileExporter(
        isPresented: self.$isReadyToSave,
        document: self.document,
        contentType: .virtualMachine,
        onCompletion: { result in
          showSaveProgress = false
          do {
            let machineSavedURL = try result.get()
            self.machineSavedURL = machineSavedURL
            Windows.openDocumentAtURL(machineSavedURL)
          } catch {
            dump(error)
          }
          self.onCompleted?(nil)
        }
      )
      .onAppear {
        guard let restoreImageID = document.machine.restoreImage?.id else {
          return
        }
        let machineRestoreImage = self.restoreImageChoices.first {
          $0.id == restoreImageID
        }
        guard let machineRestoreImage = machineRestoreImage else {
          return
        }
        DispatchQueue.main.async {
          self.machineRestoreImage = machineRestoreImage
        }
      }

      .sheet(
        item: self.$installationObject.phaseProgress,
        onDismiss: {
          DispatchQueue.main.async {
            self.isReadyToSave = true
            self.showSaveProgress = true
          }
        }, content: { phase in
          MachineFactoryView(phaseProgress: phase)
        }
      )
//      .sheet(isPresented: self.$showSaveProgress) {
//        ProgressView {
//          Text(.savingMachine)
//        }
//      }
    }
  }

  // swiftlint:enable closure_body_length

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      MachineSetupView(
        document: .constant(MachineDocument()),
        url: nil,
        restoreImageChoices: [
          MachineRestoreImage(name: "name"),

          MachineRestoreImage(name: "test"),
          MachineRestoreImage(name: "hello")
        ],
        onCompleted: nil
      )
    }
  }
#endif
