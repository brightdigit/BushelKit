//
// VZVirtioBlockDeviceConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

//
// VZVirtioBlockDeviceConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

#if arch(arm64) && canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension VZVirtioBlockDeviceConfiguration {
    convenience init(
      specification: MachineStorageSpecification,
      createDisk: Bool,
      parentDirectoryURL: URL,
      readOnly: Bool,
      using fileManager: FileManager = .default
    ) throws {
      try self.init(
        attachment:
        VZDiskImageStorageDeviceAttachment(
          specification: specification,
          createDisk: createDisk,
          parentDirectoryURL: parentDirectoryURL,
          readOnly: readOnly,
          using: fileManager
        )
      )
    }
  }
#endif
