//
// MachineDocument.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct MachineDocument: FileDocument, Identifiable {
  var machine: Machine

  var id: UUID {
    machine.id
  }

  init(machine: Machine = .init()) {
    self.machine = machine
  }
  
  mutating func validateSessionAt(_ url: URL) throws {
    self.updateFileAccessorURL(url)
    
    let manager = (machine.restoreImage?.metadata.vmSystem).flatMap(AnyImageManagers.imageManager(forSystem:))

    guard let manager = manager else {
      throw DocumentError.undefinedType("No available manager.", machine.restoreImage?.metadata.vmSystem)
    }
    
    try manager.validateSession(fromMachine: self.machine)
  }

  mutating func updateFileAccessorURL(_ url: URL) {
    guard (try? machine.rootFileAccessor?.getURL(createIfNotExists: false) != url) != true else {
      return
    }
    machine.rootFileAccessor = machine.rootFileAccessor?.updatingWithURL(url) ?? URLAccessor(url: url)
  }

  func session(fromMachine machine: Machine) throws -> MachineSession {
    let manager = (machine.restoreImage?.metadata.vmSystem).flatMap(AnyImageManagers.imageManager(forSystem:))

    guard let manager = manager else {
      throw DocumentError.undefinedType("No available manager.", machine.restoreImage?.metadata.vmSystem)
    }

    return try manager.session(fromMachine: machine)
  }

  static let readableContentTypes: [UTType] = [.virtualMachine]

  init(configuration: ReadConfiguration) throws {
    guard let machineFileWrapper = configuration.file.fileWrappers?["machine.json"] else {
      throw DocumentError.undefinedType("No machine.json file.", configuration.file)
    }
    guard let data = machineFileWrapper.regularFileContents else {
      throw DocumentError.undefinedType("No contents of machine.json file.", machineFileWrapper)
    }
    let decoder = JSONDecoder()
    var machine: Machine
    do {
      machine = try decoder.decode(Machine.self, from: data)
    } catch {
      dump(error)
      throw DocumentError.undefinedType("Decoding error for machine.json file.", error)
    }
    machine.rootFileAccessor = FileWrapperAccessor(fileWrapper: configuration.file, url: nil)

    self.init(machine: machine)
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    var rootFileWrapper: FileWrapper

    let rootURL = try machine.rootFileAccessor?.getURL()
    let machineFactoryResultURL = machine.machineFactoryResultURL

    if let rootURL = rootURL {
      if let existingFile = configuration.existingFile {
        rootFileWrapper = existingFile
      } else {
        rootFileWrapper = try FileWrapper(url: rootURL)
      }
    } else {
      rootFileWrapper = FileWrapper(directoryWithFileWrappers: [:])
    }
    guard rootFileWrapper.isDirectory else {
      throw DocumentError.undefinedType("filewrapped is not directory.", fileWrapper)
    }

    if let machineFactoryResultURL = machineFactoryResultURL {
      let machineDataWrapper = try FileWrapper(url: machineFactoryResultURL)
      machineDataWrapper.preferredFilename = "data"
      rootFileWrapper.addFileWrapper(machineDataWrapper)
    }

    let encoder = JSONEncoder()
    let data = try encoder.encode(machine)
    if let metdataFileWrapper = configuration.existingFile?.fileWrappers?["machine.json"] {
      let temporaryURL = FileManager.default.createTemporaryFile(for: .json)
      try data.write(to: temporaryURL)
      try metdataFileWrapper.read(from: temporaryURL)
    } else {
      let metdataFileWrapper = FileWrapper(regularFileWithContents: data)
      metdataFileWrapper.preferredFilename = "machine.json"
      rootFileWrapper.addFileWrapper(metdataFileWrapper)
    }

    return rootFileWrapper
  }
}
