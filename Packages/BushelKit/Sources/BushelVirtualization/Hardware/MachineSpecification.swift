//
// MachineSpecification.swift
// Copyright (c) 2023 BrightDigit.
//

public struct MachineSpecification: Codable {
  public var cpuCount: Int
  public var memorySize: UInt64
  public var storageDevices: [MachineStorageSpecification]
  public var networkConfigurations: [NetworkConfiguration]
  public var graphicsConfigurations: [GraphicsConfiguration]
  public init(
    cpuCount: Int,
    memorySize: UInt64,
    storageDevices: [MachineStorageSpecification],
    networkConfigurations: [NetworkConfiguration],
    graphicsConfigurations: [GraphicsConfiguration]
  ) {
    self.cpuCount = cpuCount
    self.memorySize = memorySize
    self.storageDevices = storageDevices
    self.networkConfigurations = networkConfigurations
    self.graphicsConfigurations = graphicsConfigurations
  }
}
