//
// VirtualizationData.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

package protocol VirtualizationDataSet {
  func data(from name: KeyPath<any VirtualizationData.Paths, String>) throws -> Data
}

public struct VirtualizationData: Sendable {
  public let machineIdentifier: MachineIdentifier
  public let hardwareModel: HardwareModel
  private init(machineIdentifier: MachineIdentifier, hardwareModel: HardwareModel) {
    self.machineIdentifier = machineIdentifier
    self.hardwareModel = hardwareModel
  }
}

public extension VirtualizationData {
  typealias Paths = URL.Bushel.Paths.VZMac

  private struct Directory: VirtualizationDataSet {
    let url: URL
    let paths: any Paths

    func data(from name: KeyPath<any Paths, String>) throws -> Data {
      let fileURL = url.appendingPathComponent(paths[keyPath: name])
      return try Data(contentsOf: fileURL)
    }
  }

  internal init(at set: any VirtualizationDataSet, using plistDecoder: PropertyListDecoder) throws {
    let machineIdentifierData = try set.data(from: \(any Paths).machineIdentifierFileName)
    let machineIdentifier = try plistDecoder.decode(MachineIdentifier.self, from: machineIdentifierData)

    let hardwareModelData = try set.data(from: \(any Paths).hardwareModelFileName)

    let hardwareModel = try plistDecoder.decode(HardwareModel.self, from: hardwareModelData)
    self.init(machineIdentifier: machineIdentifier, hardwareModel: hardwareModel)
  }

  init(
    atDataDirectory dataDirectory: URL,
    withPaths paths: any Paths,
    using plistDecoder: PropertyListDecoder
  ) throws {
    try self.init(
      at: Directory(url: dataDirectory, paths: paths),
      using: plistDecoder
    )
  }
}
