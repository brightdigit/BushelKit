//
// MachineSetupView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import BushelMachine
import SwiftUI

struct MachineSetupView: View {
  @State var machineRestoreImage: MachineRestoreImage?
  @State var isReadyToSave: Bool = false
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
            Text(choice.name)
          }
        }.padding()
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
        Text("Build Machine")
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
    }).fileExporter(isPresented: self.$isReadyToSave, document: self.document, contentType: .virtualMachine, onCompletion: { result in
      #warning("open document with result")
      dump(result)
      self.onCompleted?(nil)
    })
    .onAppear {
      DispatchQueue.main.async {
        self.machineRestoreImage = document.machine.restoreImage.map(MachineRestoreImage.init(file:))
      }
    }
    .sheet(item: self.$installationObject.phaseProgress, onDismiss: {
      DispatchQueue.main.async {
        // self.document.osInstallationCompleted()
        self.isReadyToSave = true
      }

    }) { phase in
      MachineFactoryView(phaseProgress: phase)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MachineSetupView(document: .constant(MachineDocument()), url: nil, restoreImageChoices: [
      MachineRestoreImage(name: "name"),

      MachineRestoreImage(name: "test"),
      MachineRestoreImage(name: "hello")
    ], onCompleted: nil)
  }
}
