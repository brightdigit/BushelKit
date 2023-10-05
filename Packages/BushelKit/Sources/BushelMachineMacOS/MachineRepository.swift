//
// MachineRepository.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import Virtualization

  public actor MachineRepository: LoggerCategorized {
    public static var loggingCategory: BushelLogging.Loggers.Category {
      .machine
    }

    static var alreadyCreated = false

    static let shared = MachineRepository()

    private init() {
      assert(!Self.alreadyCreated)
      Self.alreadyCreated = true
    }

    var storage = [URL: VZMachine]()

    internal func machineAt(_ url: URL, withConfiguration configuration: MachineConfiguration) async throws -> VZMachine {
      Self.logger.debug("finding machine at \(url)")
      if let machine = storage[url] {
        Self.logger.debug("found at \(url)")
        return machine
      }
      Self.logger.debug("no machine found at \(url)")
      let dataDirectory = url.appendingPathComponent(Paths.machineDataDirectoryName)
      let vzMachineConfiguration = try VZVirtualMachineConfiguration(
        contentsOfDirectory: dataDirectory,
        basedOn: configuration
      )
      try vzMachineConfiguration.validate()
      let vzMachine = VZVirtualMachine(configuration: vzMachineConfiguration)
      Self.logger.debug("creating machine at \(url)")
      let machine = await MainActor.run {
        VZMachine(url: url, configuration: configuration, machine: vzMachine)
      }
      storage[url] = machine
      return machine
    }
  }
#endif
