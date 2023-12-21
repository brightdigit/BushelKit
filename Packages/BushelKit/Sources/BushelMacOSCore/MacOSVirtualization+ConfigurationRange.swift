//
// MacOSVirtualization+ConfigurationRange.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import BushelCore
  import Foundation
  import Virtualization

  public extension MacOSVirtualization {
    static let maximumMachineCPUCount = max(ProcessInfo.processInfo.processorCount, 1)

    static let maximumAllowedCPUCount = min(
      maximumMachineCPUCount,
      VZVirtualMachineConfiguration.maximumAllowedCPUCount
    )

    static let configurationRange = ConfigurationRange(
      cpuCount:
      Float(VZVirtualMachineConfiguration.minimumAllowedCPUCount) ... Float(Self.maximumAllowedCPUCount),
      memory:
      // swiftlint:disable:next line_length
      Float(VZVirtualMachineConfiguration.minimumAllowedMemorySize) ... Float(VZVirtualMachineConfiguration.maximumAllowedMemorySize)
    )
  }
#endif
