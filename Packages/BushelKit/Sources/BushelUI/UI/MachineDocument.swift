//
// MachineDocument.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers) && os(macOS)
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
      updateFileAccessorURL(url)

      let manager = (machine.restoreImage?.metadata.vmSystem)
        .flatMap(AnyImageManagers.imageManager(forSystem:))

      guard let manager = manager else {
        throw DocumentError.undefinedType("No available manager.", machine.restoreImage?.metadata.vmSystem)
      }

      try manager.validateSession(fromMachine: machine)
    }

    mutating func updateFileAccessorURL(_ url: URL) {
      guard (try? machine.rootFileAccessor?.getURL(createIfNotExists: false) != url) != true else {
        return
      }
      machine.rootFileAccessor = machine.rootFileAccessor?.updatingWithURL(url) ?? URLAccessor(url: url)
    }

    static let readableContentTypes: [UTType] = [.virtualMachine]

    init(configuration: ReadConfiguration) throws {
      guard let machineFileWrapper = configuration.file.fileWrappers?[Paths.machineJSONFileName] else {
        throw DocumentError.undefinedType("No machine.json file.", configuration.file)
      }
      guard let data = machineFileWrapper.regularFileContents else {
        throw DocumentError.undefinedType("No contents of machine.json file.", machineFileWrapper)
      }

      var machine: Machine
      do {
        machine = try Configuration.JSON.tryDecoding(data)
      } catch {
        throw DocumentError.innerError(error, "Decoding error for machine.json file.", nil)
      }
      machine.rootFileAccessor = FileWrapperAccessor(fileWrapper: configuration.file, url: nil)

      self.init(machine: machine)
      ApplicationContext.shared.refreshRecentDocuments()
    }

    // swiftlint:disable:next function_body_length
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
        machineDataWrapper.preferredFilename = Paths.machineDataDirectoryName
        rootFileWrapper.addFileWrapper(machineDataWrapper)
      }

      let data = try Configuration.JSON.encoder.encode(machine)

      if let metdataFileWrapper = configuration.existingFile?.fileWrappers?[Paths.machineJSONFileName] {
        let temporaryURL = FileManager.default.createTemporaryFile(for: .json)
        try data.write(to: temporaryURL)
        try metdataFileWrapper.read(from: temporaryURL)
      } else {
        let metdataFileWrapper = FileWrapper(regularFileWithContents: data)
        metdataFileWrapper.preferredFilename = Paths.machineJSONFileName
        rootFileWrapper.addFileWrapper(metdataFileWrapper)
      }

      return rootFileWrapper
    }

    mutating func addSnapshot(isDiscardable: Bool = false) throws {
      guard let url = try machine.rootFileAccessor?.getURL() else {
        throw DocumentError.undefinedType("Missing URL for Versioning", nil)
      }
      let version: NSFileVersion
      do {
        version = try NSFileVersion.addOfItem(at: url, withContentsOf: url, options: [])
      } catch {
        throw DocumentError.innerError(error, "Couldn't create file version", url)
      }
      if isDiscardable {
        version.isDiscardable = true
      }
      try machine.snapshots.append(.init(fileVersion: version))
    }
  }
#endif
