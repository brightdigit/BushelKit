//
// MacOSVirtualizationMachineSystem.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)

  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelMacOSCore
  import Foundation
  import SwiftUI
  import Virtualization

  public struct MacOSVirtualizationMachineSystem: MachineSystem {
    public typealias RestoreImageType = VirtualizationMacOSRestoreImage

    public var repository: MachineRepository {
      .shared
    }

    public var id: VMSystemID {
      .macOS
    }

    public init() {}

    public func machine(
      at url: URL,
      withConfiguration configuration: MachineConfiguration
    ) async throws -> any BushelMachine.Machine {
      try await self.repository.machineAt(url, withConfiguration: configuration)
    }

    public func restoreImage(
      from restoreImage: any InstallerImage
    ) async throws -> VirtualizationMacOSRestoreImage {
      let url = try restoreImage.getURL()
      return try await .init(url: url)
    }

    public func validateConfiguration(
      _ configuration: BushelMachine.MachineBuildConfiguration<VirtualizationMacOSRestoreImage>,
      to url: URL
    ) throws {
      try self.validatedMachineConfiguration(for: configuration, at: url)
    }

    @discardableResult
    func validatedMachineConfiguration(
      for configuration: BushelMachine.MachineBuildConfiguration<VirtualizationMacOSRestoreImage>,
      at url: URL
    ) throws -> VZVirtualMachineConfiguration {
      let machineConfiguration: VZVirtualMachineConfiguration

      // setState(atPhase: .building)

      machineConfiguration = try VZVirtualMachineConfiguration(
        toDirectory: url,
        basedOn: configuration.configuration,
        withRestoreImage: configuration.restoreImage.image
      )
      try machineConfiguration.validate()

      return machineConfiguration
    }

    @MainActor
    public func createBuilder(
      for configuration: BushelMachine.MachineBuildConfiguration<VirtualizationMacOSRestoreImage>,
      at url: URL
    ) throws -> BushelMachine.MachineBuilder {
      let machineConfiguration = try self.validatedMachineConfiguration(for: configuration, at: url)

      let virtualMachine = VZVirtualMachine(configuration: machineConfiguration)

      let installer = VZMacOSInstaller(
        virtualMachine: virtualMachine,
        restoringFromImageAt: configuration.restoreImage.url
      )

      return VirtualizationInstaller(url: url, installer: installer)
    }
  }
#endif
