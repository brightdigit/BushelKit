//
// MachineSetupView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineSetupView: View {
    internal init(
      document: Binding<MachineDocument>,
      machineRestoreImage: RestoreImageContextChoice? = nil,
      isReadyToSave: Bool = false,
      machineSavedURL: URL? = nil,
      url: URL? = nil,
      onCompleted: ((Error?) -> Void)? = nil
    ) {
      _document = document
      self.url = url
      self.onCompleted = onCompleted
      _machineRestoreImage =
        .init(
          initialValue:
          machineRestoreImage?.id ??
            RestoreImageContextChoice.none.id
        )
      self.isReadyToSave = isReadyToSave
      self.machineSavedURL = machineSavedURL
    }

    @Environment(\.dismiss) var dismiss: DismissAction
    @State var machineRestoreImage: UUID = RestoreImageContextChoice.none.id
    @State var isReadyToSave = false
    @State var machineSavedURL: URL?
    @Binding var document: MachineDocument
    let url: URL?
    @EnvironmentObject var appContext: ApplicationContext
    @StateObject var installationObject = MachineInstallationObject()

    let onCompleted: ((Error?) -> Void)?

    var restoreImageChoices: [RestoreImageContextChoice] {
      var choices = appContext.images.map(
        RestoreImageContextChoice.init
      )
      choices.insert(.none, at: 0)
      return choices
    }

    var body: some View {
      VStack {
        if document.machine.operatingSystem == nil {
          Picker("Restore Image", selection: self.$machineRestoreImage) {
            ForEach(restoreImageChoices) { choice in
              Text(choice.name ?? "No Restore Image Available").tag(choice.id)
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
        DispatchQueue.main.async {
          self.machineRestoreImage = restoreImageID
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
        document: .constant(MachineDocument()),
        machineRestoreImage: .image(.init(name: "test")),
        url: nil,
        onCompleted: nil
      )
    }
  }
#endif
