//
//  BshIllDocument.swift
//  BshIll
//
//  Created by Leo Dion on 6/22/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct MachineDocument: CreatableFileDocument, Identifiable {
  var machine: Machine
  var sourceURL: URL?
  let sessionObject: MachineSessionObject = .init()

  var session : MachineSession? {
    return sessionObject.session
  }
  var id: UUID {
    machine.id
  }
  
  init(machine : Machine = .init(), sourceURL:URL? = nil) {
    self.machine = machine
    self.sourceURL = nil
  }
  
  mutating func setConfiguration(_ configuration: MachineConfiguration) {
    self.machine.configurationURL = configuration.currentURL
  }
  
  mutating func beginLoadingFromURL(_ url: URL) throws {
    self.machine.configurationURL = url
    
    let session = try self.machine.createMachine()
    sessionObject.session = session
    
  }
  
  mutating func osInstallationCompleted (withConfiguration configuration: MachineConfiguration) {
    guard let metadata = self.machine.restoreImage?.metadata else {
      return
    }
    self.machine.setConfiguration(configuration)
    self.machine.operatingSystem = .init(type: .macOS, version: metadata.operatingSystemVersion, buildVersion: metadata.buildVersion)
  }
  
  static let untitledDocumentType: UTType = .virtualMachine
  static let readableContentTypes: [UTType] = [.virtualMachine]
  
  init(configuration: ReadConfiguration) throws {
    
    guard let machineFileWrapper = configuration.file.fileWrappers?["machine.json"] else {
      throw NSError()
    }
    guard let data = machineFileWrapper.regularFileContents else {
      throw NSError()
    }
    let decoder = JSONDecoder()
    let machine = try decoder.decode(Machine.self, from: data)
    //machine.fileWrapper = configuration.file
    self.init(machine: machine)
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    var fileWrapper : FileWrapper
    if let configurationURL = machine.configurationURL {
      if let existingFile = configuration.existingFile, configurationURL == sourceURL {
        fileWrapper = existingFile
      } else {
        fileWrapper = try FileWrapper(url: configurationURL)
      }
    } else {
      fileWrapper = FileWrapper(directoryWithFileWrappers: [:])
    }
    guard fileWrapper.isDirectory else {
      throw NSError()
    }
    let encoder = JSONEncoder()
    let data = try encoder.encode(self.machine)
    if let metdataFileWrapper = configuration.existingFile?.fileWrappers?["machine.json"] {
      let temporaryURL = FileManager.default.createTemporaryFile(for: .json)
      try data.write(to: temporaryURL)
      try metdataFileWrapper.read(from: temporaryURL)
    } else {
      let metdataFileWrapper = FileWrapper(regularFileWithContents: data)
      metdataFileWrapper.preferredFilename = "machine.json"
      fileWrapper.addFileWrapper(metdataFileWrapper)
    }
    
    return fileWrapper
  }
}
