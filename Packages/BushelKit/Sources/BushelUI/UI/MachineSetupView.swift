//
// MachineSetupView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineSetupView: View {
    internal init(
      // document: Binding<MachineDocument>,
      machineRestoreImage: RestoreImageContextChoice? = nil,
      // isReadyToSave: Bool = false,
      machineSavedURL: URL? = nil,
      url: URL? = nil,
      onCompleted: ((Error?) -> Void)? = nil
    ) {
      // _document = document
      self.url = url
      self.onCompleted = onCompleted
      _machineRestoreImage =
        .init(
          initialValue:
          machineRestoreImage?.id ??
            RestoreImageContextChoice.none.id
        )
      // self.isReadyToSave = isReadyToSave
      self.machineSavedURL = machineSavedURL
    }

    @Environment(\.dismiss) var dismiss: DismissAction
    @State var machineRestoreImage: UUID = RestoreImageContextChoice.none.id
    // @State var isReadyToSave = false
    @State var machineSavedURL: URL?
    // @Binding var document: MachineDocument
    @State var machine = Machine()
    let url: URL?
    @EnvironmentObject var appContext: ApplicationContext
    @StateObject var installationObject = MachineInstallationObject()

    let onCompleted: ((Error?) -> Void)?

    func buildingCancelled() {
      DispatchQueue.main.async {
        self.installationObject.cancel()
      }
    }

    var restoreImageChoices: [RestoreImageContextChoice] {
      var choices = appContext.images.map(
        RestoreImageContextChoice.init
      )
      if choices.isEmpty {
        choices.insert(.none, at: 0)
      }
      return choices
    }

    var selectedRestoreImageFile: RestoreImageLibraryItemFile? {
      let restoreImageChoice = restoreImageChoices.first { $0.id == self.machineRestoreImage
      }

      guard let restoreImage = restoreImageChoice?.machineRestoreImage?.image else {
        return nil
      }

      return RestoreImageLibraryItemFile(loadFromImage: restoreImage)
    }

    var body: some View {
      VStack {
        if machine.operatingSystem == nil {
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
            guard let selectedRestoreImageFile = selectedRestoreImageFile else {
              return
            }
            self.machine.restoreImage = selectedRestoreImageFile
            let savePanel = NSSavePanel()
            savePanel.nameFieldLabel = "Save Restore Image as:"

            savePanel.allowedContentTypes = [.virtualMachine]
            savePanel.isExtensionHidden = true

            savePanel.begin { response in
              guard let fileURL = savePanel.url, response == .OK else {
                return
              }

              let dataURL = fileURL.appendingPathComponent("data")
              Task {
                let factory: VirtualMachineFactory
                do {
                  factory = try await machine.build()
                } catch {
                  Self.logger.error("failure building machine: \(error.localizedDescription)")
                  return
                }
                installationObject.setupInstaller(factory)
                factory.beginBuild(at: dataURL)
              }
              self.machineSavedURL = fileURL
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
            self.machine.installationCompletedAt(machineConfigurationURL)

            guard let machineSavedURL = self.machineSavedURL else {
              Self.logger.error("missing machine url")
              return
            }
            let machineURL = machineSavedURL.appendingPathComponent("machine.json")
            do {
              try Configuration.JSON.encoder.encode(self.machine).write(to: machineURL)
            } catch {
              Self.logger.error("unable to save machine at: \(error.localizedDescription)")
            }
            self.installationObject.cancel()

            Windows.openDocumentAtURL(machineSavedURL)
            self.dismiss()
          }

        case let .failure(error):
          self.onCompleted?(error)
        }
      })

      .onAppear {
        let restoreImageID = machine.restoreImage?.id ?? self.restoreImageChoices.first?.id
        guard let restoreImageID = restoreImageID else {
          return
        }
        DispatchQueue.main.async {
          self.machineRestoreImage = restoreImageID
        }
      }

      .sheet(
        item: self.$installationObject.phaseProgress,
        content: { phase in
          MachineFactoryView(phaseProgress: phase, onCancel: self.buildingCancelled)
        }
      )
    }
  }

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      MachineSetupView(
        machineRestoreImage: .image(.init(name: "test")),
        url: nil,
        onCompleted: nil
      )
    }
  }
#endif
