//
// MacOSVirtualizationMachineSystem.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)

  public import BushelCore
  import BushelLogging

  public import BushelMachine
  import BushelMacOSCore

  public import Foundation
  import SwiftUI
  import Virtualization

  public struct MacOSVirtualizationMachineSystem: MachineSystem {
    public typealias RestoreImageType = VirtualizationRestoreImage

    public var repository: MachineRepository {
      .shared
    }

    public var id: VMSystemID {
      .macOS
    }

    public let defaultStorageLabel: String = "macOS System"

    public let defaultSnapshotSystem: BushelCore.SnapshotterID = .fileVersion

    public init() {}

    public func machine(
      at url: URL,
      withConfiguration configuration: MachineConfiguration
    ) async throws -> any BushelMachine.Machine {
      try await self.repository.machineAt(url, withConfiguration: configuration)
    }

    public func restoreImage(
      from restoreImage: any InstallerImage
    ) async throws -> VirtualizationRestoreImage {
      let url = try await restoreImage.getURL()
      return try await .init(url: url)
    }

    public func configurationRange(for _: any InstallerImage) -> ConfigurationRange {
      MacOSVirtualization.configurationRange
    }

    @discardableResult
    func validatedMachineConfiguration(
      for configuration: BushelMachine.MachineBuildConfiguration<VirtualizationRestoreImage>,
      at url: URL
    ) throws -> VZVirtualMachineConfiguration {
      let machineConfiguration: VZVirtualMachineConfiguration

      machineConfiguration = try VZVirtualMachineConfiguration(
        toDirectory: url,
        basedOn: configuration.configuration,
        withRestoreImage: configuration.restoreImage.image
      )
      try machineConfiguration.validate()

      return machineConfiguration
    }

    #warning("logging-note: why not mention that a configuration has been validated")
    @MainActor
    public func createBuilder(
      for configuration: BushelMachine.MachineBuildConfiguration<VirtualizationRestoreImage>,
      at url: URL
    ) throws -> any MachineBuilder {
      VirtualizationMachineBuilder(url: url, installer: {
        let machineConfiguration = try self.validatedMachineConfiguration(for: configuration, at: url)
        let virtualMachine = VZVirtualMachine(configuration: machineConfiguration)
        return VZMacOSInstaller(
          virtualMachine: virtualMachine,
          restoringFromImageAt: configuration.restoreImage.url
        )
      })
    }
  }
#endif
