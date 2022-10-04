//
// MachineSetupView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineSetupView: View {
    internal init(
      machineRestoreImage: MachineRestoreImage? = nil,
      isReadyToSave: Bool = false,
      machineSavedURL: URL? = nil,
      document: Binding<MachineDocument>,
      url: URL? = nil,
      restoreImageChoices: [MachineRestoreImage],
      onCompleted: ((Error?) -> Void)? = nil
    ) {
      _document = document
      self.url = url
      self.restoreImageChoices = restoreImageChoices.isEmpty ? [MachineSetupView.unavailableRestoreImageChoice] : restoreImageChoices
      self.onCompleted = onCompleted
      _machineRestoreImage = .init(initialValue: machineRestoreImage ?? restoreImageChoices.first ?? MachineSetupView.unavailableRestoreImageChoice)
      self.isReadyToSave = isReadyToSave
      self.machineSavedURL = machineSavedURL
    }

    static let unavailableRestoreImageChoice = MachineRestoreImage(name: "No Available Restore Image")

    @Environment(\.dismiss) var dismiss: DismissAction
    @State var machineRestoreImage: MachineRestoreImage
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
              Text(choice.name).tag(choice)
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
                Self.logger.error("failure building machine: \(error.localizedDescription)")
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
        guard case let .savedAt(result) = phase?.phase else {
          return
        }
        switch result {
        case let .success(machineConfigurationURL):
          DispatchQueue.main.async {
            self.document.machine.installationCompletedAt(machineConfigurationURL)
            self.isReadyToSave = true
          }

        case let .failure(error):
          self.onCompleted?(error)
        }
      })

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
        content: { phase in
          VStack {
            MachineFactoryView(phaseProgress: phase).fileExporter(
              isPresented: self.$isReadyToSave,
              document: self.document,
              contentType: .virtualMachine,
              onCompletion: { result in
                do {
                  self.installationObject.cancel()
                  let machineSavedURL = try result.get()
                  self.machineSavedURL = machineSavedURL
                  Windows.openDocumentAtURL(machineSavedURL)
                } catch {
                  Self.logger.error("failure saving machine: \(error.localizedDescription)")
                }
                self.onCompleted?(nil)
              }
            )
          }
        }
      )
    }
  }

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      MachineSetupView(
        machineRestoreImage: MachineRestoreImage(name: "test"), document: .constant(MachineDocument()),
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
