//
// MachineDocument.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
import UniformTypeIdentifiers

enum DocumentError: Error {
  case undefinedType(String, Any?)
}

struct MachineDocument: CreatableFileDocument, Identifiable {
  var machine: Machine
  var sourceURL: URL?
  let sessionObject: MachineSessionObject = .init()

  var session: MachineSession? {
    sessionObject.session
  }

  var id: UUID {
    machine.id
  }

  init(machine: Machine = .init(), sourceURL _: URL? = nil) {
    self.machine = machine
    sourceURL = nil
  }

  mutating func setConfiguration(_ configuration: MachineConfiguration) {
    machine.configurationURL = configuration.currentURL
  }

  func session(fromMachine machine: Machine) throws -> MachineSession {
    let manager = (machine.restoreImage?.metadata.vmSystem).flatMap(AnyImageManagers.imageManager(forSystem:))

    guard let manager = manager else {
      throw DocumentError.undefinedType("No available manager.", machine.restoreImage?.metadata.vmSystem)
    }

    return try manager.session(fromMachine: machine)
  }

  mutating func beginLoadingFromURL(_ url: URL) throws {
    machine.configurationURL = url
    let session = try session(fromMachine: machine)
    sessionObject.session = session
  }

  mutating func osInstallationCompleted(withConfiguration configuration: MachineConfiguration) {
    guard let metadata = machine.restoreImage?.metadata else {
      return
    }
    machine.setConfiguration(configuration)

    machine.operatingSystem = .init(type: .macOS, version: metadata.operatingSystemVersion, buildVersion: metadata.buildVersion)
  }

  static let untitledDocumentType: UTType = .virtualMachine
  static let readableContentTypes: [UTType] = [.virtualMachine]

  init(configuration: ReadConfiguration) throws {
    guard let machineFileWrapper = configuration.file.fileWrappers?["machine.json"] else {
      throw DocumentError.undefinedType("No machine.json file.", configuration.file)
    }
    guard let data = machineFileWrapper.regularFileContents else {
      throw DocumentError.undefinedType("No contents of machine.json file.", machineFileWrapper)
    }
    let decoder = JSONDecoder()
    let machine: Machine
    do {
      machine = try decoder.decode(Machine.self, from: data)
    } catch {
      dump(error)
      throw DocumentError.undefinedType("Decoding error for machine.json file.", error)
    }
    // machine.fileWrapper = configuration.file
    self.init(machine: machine)
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    var fileWrapper: FileWrapper
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
      throw DocumentError.undefinedType("filewrapped is not directory.", fileWrapper)
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
      fileWrapper.addFileWrapper(metdataFileWrapper)
    }

    return fileWrapper
  }
}
