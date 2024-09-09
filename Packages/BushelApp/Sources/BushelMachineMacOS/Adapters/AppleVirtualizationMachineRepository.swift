//
// AppleVirtualizationMachineRepository.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore

  public import BushelLogging
  import BushelMachine
  import Foundation
  import Virtualization

  public actor AppleVirtualizationMachineRepository: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .machine
    }

    internal static let shared = AppleVirtualizationMachineRepository()
    var storage = [URL: AppleVirtualizationMachine]()

    private init() {}

    internal func machineAt(
      _ url: URL,
      withConfiguration configuration: MachineConfiguration
    ) async throws -> AppleVirtualizationMachine {
      Self.logger.debug("finding machine at \(url)")
      if let machine = storage[url] {
        Self.logger.debug("found at \(url)")
        return machine
      }
      Self.logger.debug("no machine found at \(url)")
      let dataDirectory = url.appendingPathComponent(URL.bushel.paths.machineDataDirectoryName)

      let machineData = try VirtualizationData(
        atDataDirectory: dataDirectory,
        withPaths: URL.bushel.paths.vzMac,
        using: .init()
      )

      Self.logger.debug("creating machine at \(url)")

      let machine = try await AppleVirtualizationMachine(url: url, machineIdentifer: machineData.machineIdentifier.ecID, configuration: configuration) {
        let vzMachineConfiguration = try VZVirtualMachineConfiguration(
          contentsOfDirectory: dataDirectory,
          basedOn: configuration
        )
        try vzMachineConfiguration.validate()
        return VZVirtualMachine(configuration: vzMachineConfiguration)
      }

//      let machine = AppleVirtualizationMachine
      storage[url] = machine
      return machine
    }
  }
#endif
