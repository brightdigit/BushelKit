//
//  ContentView.swift
//  BshillRunner
//
//  Created by Leo Dion on 6/19/22.
//

import SwiftUI
import Virtualization


extension VZMacPlatformConfiguration {
    convenience init(fromDirectory machineDirectory: URL) throws {
        self.init()
        let auxiliaryStorageURL = machineDirectory.appendingPathComponent("auxiliary.storage")
        let hardwareModelURL = machineDirectory.appendingPathComponent("hardware.model.bin")
        let machineIdentifierURL = machineDirectory.appendingPathComponent("machine.identifier.bin")
        if #available(macOS 13.0, *) {
            //self.auxiliaryStorage = VZMacAuxiliaryStorage(url: auxiliaryStorageURL)
        } else {
            self.auxiliaryStorage = VZMacAuxiliaryStorage(contentsOf: auxiliaryStorageURL)
            // Fallback on earlier versions
        }
        
        guard let hardwareModel = VZMacHardwareModel(dataRepresentation: try Data(contentsOf: hardwareModelURL) ) else {
            throw NSError()
        }
        self.hardwareModel = hardwareModel
        guard let machineIdentifier = VZMacMachineIdentifier(dataRepresentation: try .init(contentsOf: machineIdentifierURL)) else {
            throw NSError()
        }
        self.machineIdentifier = machineIdentifier
    }
    convenience init(restoreImage : VZMacOSRestoreImage, in machineDirectory: URL) throws
    {
        self.init()
        
        
        guard let configuration = restoreImage.mostFeaturefulSupportedConfiguration else {
          throw NSError()
        }
        
        try FileManager.default.createDirectory(at: machineDirectory, withIntermediateDirectories: true)
        let auxiliaryStorageURL = machineDirectory.appendingPathComponent("auxiliary.storage")
        let hardwareModelURL = machineDirectory.appendingPathComponent("hardware.model.bin")
        let machineIdentifierURL = machineDirectory.appendingPathComponent("machine.identifier.bin")
        
        let auxiliaryStorage = try VZMacAuxiliaryStorage(creatingStorageAt: auxiliaryStorageURL,
                                                          hardwareModel: configuration.hardwareModel,
                                                                options: [])
        
        self.auxiliaryStorage = auxiliaryStorage
        self.hardwareModel = configuration.hardwareModel
        self.machineIdentifier = .init()
        
        try self.hardwareModel.dataRepresentation.write(to: hardwareModelURL)
        try self.machineIdentifier.dataRepresentation.write(to: machineIdentifierURL)
    }
}

struct StartMachineView: View {
    @State var isImporting : Bool = false
    @State var restoreImage: VZMacOSRestoreImage?
    @State var machine: VZVirtualMachine?
  
  let installWith: (VZMacOSRestoreImage, VZVirtualMachine) -> Void
    let startMachine: (VZVirtualMachine) -> Void
  
    var body: some View {
        VStack {
            HStack{
                Button("Import") {
                    let panel = NSOpenPanel()
                    panel.nameFieldLabel = "Open Restore Image:"
                    panel.allowedContentTypes = [.init("com.apple.itunes.ipsw")!, .init("com.apple.iphone.ipsw")!]
                    panel.isExtensionHidden = true
                    panel.begin { response in
                      guard let fileURL = panel.url, response == .OK else {
                        return
                      }
                        DispatchQueue.main.async {
                            self.isImporting = true
                        }
                      VZMacOSRestoreImage.load(from: fileURL) { result in
                          DispatchQueue.main.async {
                              self.isImporting = false
                          }
                          let image : VZMacOSRestoreImage
                          do {
                              image = try result.get()
                          } catch {
                              dump(error)
                              return 
                          }
                        DispatchQueue.main.async {
                            self.restoreImage = image
                        }
                      }
                    }
                }
                Group {
                    if self.isImporting {
                        ProgressView()
                    } else {
                        Text(self.restoreImage?.buildVersion ?? "No Image Imported")
                    }
                }
            }
            HStack{
                Button("Build") {
                    guard let image = self.restoreImage else {
                        return
                    }
                    let panel = NSSavePanel()
                    panel.nameFieldLabel = "Save Machine at:"
                    panel.allowedContentTypes =  [.directory]
                    //panel.allowedContentTypes = [.init("com.apple.itunes.ipsw")!, .init("com.apple.iphone.ipsw")!]
                    //panel.isExtensionHidden = true
                    panel.begin { response in
                      
                      guard let fileURL = panel.url, response == .OK else {
                        return
                      }
                        
                        let configuration : VZVirtualMachineConfiguration
                        do {
                            configuration = try VZVirtualMachineConfiguration(restoreImage: image, in: fileURL)
                            try configuration.validate()
                            
                        } catch {
                            dump(error)
                            return
                        }
                      
                        DispatchQueue.main.async {
                            self.machine = VZVirtualMachine(configuration: configuration)
                        }
                    }
                }
                Text("Machine Built")
            }.disabled(self.restoreImage == nil)
            HStack{
                Button("Install Image") {
                  guard let restoreImage = restoreImage, let machine = machine else {
                        return
                    }
                  self.installWith(restoreImage, machine)
                    
//                    machine.start { result in
//                        dump(result)
//                    }
                    
                }.disabled(self.machine == nil)
            }
            HStack{
                Button("Open Machine") {
                    let panel = NSOpenPanel()
                    panel.nameFieldLabel = "Open Machine:"
                    panel.allowedContentTypes =  [.directory]
                    panel.canChooseFiles = false
                    panel.canChooseDirectories = true
                    panel.begin { response in
                      guard let fileURL = panel.url, response == .OK else {
                        return
                      }
                        let configuration : VZVirtualMachineConfiguration
                        do {
                            configuration = try VZVirtualMachineConfiguration(contentsOfDirectory: fileURL)
                            try configuration.validate()
                        } catch {
                            dump(error)
                            return
                        }
                        
                        let machine = VZVirtualMachine(configuration: configuration)
                        
                        DispatchQueue.main.async {
                            self.machine = machine
                        }
                    }
                }
            }
            HStack{
                Button("Start") {
                    
                    guard let machine = machine else {
                          return
                      }
                    self.startMachine(machine)
                      
  //                    machine.start { result in
  //                        dump(result)
  //                    }
                }
            }
        }.padding()
    }
}

struct StartMachineView_Previews: PreviewProvider {
    static var previews: some View {
      StartMachineView { _, _ in
        
      } startMachine: { _ in
          
      }
    }
}
