//
//  ContentView.swift
//  BshIll
//
//  Created by Leo Dion on 6/22/22.
//

import SwiftUI

struct MachineSetupView: View {
  
  @State var machinePreparing : MachinePreparationState? = nil
  @State var machineRestoreImage : MachineRestoreImage?
  @State var isReadyToSave: Bool = false
  @Binding var document: MachineDocument
  @State var configuration: MachineConfiguration?
  let url: URL?
  let restoreImageChoices : [MachineRestoreImage]
  @StateObject var installationObject = MachineInstallationObject()

  let onCompleted : ((Error?) -> Void)?
  
  
  var body: some View {
    VStack{
      if document.machine.operatingSystem == nil {
        Picker("Restore Image", selection: self.$machineRestoreImage) {
          ForEach(restoreImageChoices) { choice in
            Text(choice.name)
          }
        }.padding()
      }
      Button {
        if !document.machine.isBuilt {
          self.machinePreparing = .building
        } else if document.machine.operatingSystem == nil {
          self.machinePreparing = .installing
        } else {
        }
        
      } label: {
        Text("Build Machine")
      }
      
    }.onReceive(self.installationObject.$isCompletedWithError, perform: { completed in
      guard let completed = completed  else {
        return
      }
      do {
        try completed.get()
      } catch {
        dump(error)
        self.onCompleted?(error)
        return
      }
      Task {
        await MainActor.run {
          
          self.machinePreparing = .none
          
        }
      }
      
    }).fileExporter(isPresented: self.$isReadyToSave, document: self.document, contentType: .virtualMachine, onCompletion: { result in
      #warning("open document with result")
      dump(result)
      self.onCompleted?(nil)
    })
    .onAppear{
      self.machineRestoreImage = document.machine.restoreImage.map(MachineRestoreImage.init(file:))
    }.sheet(item: self.$machinePreparing, onDismiss: {
      DispatchQueue.main.async {
        
        //self.document.machine.setConfiguration(configuration)
        self.document.osInstallationCompleted(withConfiguration: self.configuration!)
        self.isReadyToSave = true
      }
      
    }) { state in
      VStack{
        HStack{
          Image(systemName: state == .building ? "play.fill" : "checkmark.circle.fill")
          Text("Building Machine...")
        }
        HStack{
          Image(systemName: state == .installing ? "play.fill" : "checkmark.circle.fill")
          ProgressView(value: self.installationObject.progressValue) {
            Text("Installing Operating System...")
          }
        }
        
      }.task {
        guard let installer = try? await document.machine.createInstaller() else {
          return
        }
        let vInstaller : VirtualInstaller
        do {
          let configuration = try document.machine.build(withInstaller: installer)
          DispatchQueue.main.async {
            
            self.machinePreparing = .installing
            self.document.setConfiguration(configuration)
            self.configuration = configuration
          }
          vInstaller = try document.machine.startInstallation(with: installer, using: configuration)
        } catch {
          return
        }
        installationObject.setupInstaller(vInstaller)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MachineSetupView(document: .constant(MachineDocument()), url: nil, restoreImageChoices: [
      MachineRestoreImage(name: "name", id: "name"),
      
      MachineRestoreImage(name: "test", id: "test"),
      MachineRestoreImage(name: "hello", id: "hello")
    ], onCompleted: nil)
  }
}
