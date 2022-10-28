//
// VirtualizationImageManager.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelMachine
  import Foundation
  import UniformTypeIdentifiers
  import Virtualization

  public struct VirtualizationImageManager: ImageManager {
    public func imageNameFor(operatingSystemVersion: OperatingSystemVersion) -> String? {
      Self.codeNames[operatingSystemVersion.majorVersion]?.prepending("OSVersions/")
    }

    public let supportedSystems: [OperatingSystemDetails.System] = [.macOS]

    public static let codeNames: [Int: String] = [
      11: "Big Sur",
      12: "Monterey",
      13: "Ventura"
    ]
    public func defaultSpecifications() -> BushelMachine.MachineSpecification {
      .init(
        cpuCount: VZVirtualMachineConfiguration.computeCPUCount(),
        memorySize: VZVirtualMachineConfiguration.computeMemorySize(),
        storageDevices: [.init(id: .init(), size: VZVirtualMachineConfiguration.minimumHardDiskSize)],
        networkConfigurations: [.init(attachment: .nat)],
        graphicsConfigurations: [.init(displays: [.init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)])]
      )
    }

    static let defaultNamePrefix = "macOS"

    public static let restoreImageContentTypes = UTType.ipswTypes
    public static var systemID = VMSystemID.macOS

    public init() {}

    @MainActor
    public func loadFromAccessor(
      _ accessor: FileAccessor
    ) async throws -> VZMacOSRestoreImage {
      try await VZMacOSRestoreImage.loadFromURL(accessor.getURL())
    }

    public func containerFor(
      image: VZMacOSRestoreImage,
      fileAccessor: FileAccessor?
    ) async throws -> ImageContainer {
      try await VirtualizationMacOSRestoreImage(
        vzRestoreImage: image,
        fileAccessor: fileAccessor
      )
    }

    public func validateSession(fromMachine machine: Machine) throws {
      guard let configurationURL = try machine.getMachineConfigurationURL() else {
        throw VirtualizationError.undefinedType("Missing configurationURL for session", self)
      }
      let specifications = machine.specification
      try VirtualizationSession.validate(fromConfigurationURL: configurationURL, basedOn: specifications)
    }

    public func session(fromMachine machine: Machine) throws -> MachineSession {
      guard let configurationURL = try machine.getMachineConfigurationURL() else {
        throw VirtualizationError.undefinedType("Missing configurationURL for session", self)
      }
      let specifications = machine.specification
      return try VirtualizationSession(fromConfigurationURL: configurationURL, basedOn: specifications)
    }

    public func buildMachine(
      _ machine: Machine,
      restoreImage: VZMacOSRestoreImage
    ) -> VirtualMachineFactory {
      VirtualMacOSMachineFactory(machine: machine, restoreImage: restoreImage)
    }

    public func restoreImage(
      from fileAccessor: FileAccessor
    ) async throws -> VZMacOSRestoreImage {
      try await VZMacOSRestoreImage.loadFromURL(fileAccessor.getURL())
    }

    public func codeNameFor(operatingSystemVersion: OperatingSystemVersion) -> String {
      Self.codeNames[operatingSystemVersion.majorVersion] ?? operatingSystemVersion.majorVersion.description
    }
  }
#endif
