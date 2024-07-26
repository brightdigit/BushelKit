//
// MachineRepository.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore

  public import BushelLogging
  import BushelMachine
  import Foundation
  import Virtualization

  public actor MachineRepository: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .machine
    }

    internal static let shared = MachineRepository()
    var storage = [URL: VirtualizationMachine]()

    private init() {}

    internal func machineAt(
      _ url: URL,
      withConfiguration configuration: MachineConfiguration
    ) async throws -> VirtualizationMachine {
      Self.logger.debug("finding machine at \(url)")
      if let machine = storage[url] {
        Self.logger.debug("found at \(url)")
        return machine
      }
      Self.logger.debug("no machine found at \(url)")
      let dataDirectory = url.appendingPathComponent(URL.bushel.paths.machineDataDirectoryName)
      let vzMachineConfiguration = try VZVirtualMachineConfiguration(
        contentsOfDirectory: dataDirectory,
        basedOn: configuration
      )
      try vzMachineConfiguration.validate()
      let vzMachine = VZVirtualMachine(configuration: vzMachineConfiguration)

      let machineData = try VirtualizationData(
        atDataDirectory: dataDirectory,
        withPaths: URL.bushel.paths.vzMac,
        using: .init()
      )

      Self.logger.debug("creating machine at \(url)")
      let machine = await MainActor.run {
        VirtualizationMachine(url: url, configuration: configuration, machine: vzMachine, data: machineData)
      }
      storage[url] = machine
      return machine
    }
  }
#endif
