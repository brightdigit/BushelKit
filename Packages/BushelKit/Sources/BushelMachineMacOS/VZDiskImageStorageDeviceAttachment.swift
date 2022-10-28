//
// VZDiskImageStorageDeviceAttachment.swift
// Copyright (c) 2022 BrightDigit.
//

#if arch(arm64) && canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension VZDiskImageStorageDeviceAttachment {
    convenience init(specification: MachineStorageSpecification, createDisk: Bool, parentDirectoryURL: URL, readOnly: Bool, using fileManager: FileManager) throws {
      let diskImageURL = parentDirectoryURL
        .appendingPathComponent(specification.id.uuidString)
        .appendingPathExtension("img")
      if createDisk {
        try fileManager
          .createFile(
            atPath: diskImageURL.path,
            withSize: FileSize(specification.size)
          )
      }

      try self.init(url: diskImageURL, readOnly: readOnly)
    }
  }
#endif
