//
// VirtualizationData.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

/// A protocol defining a contract for retrieving data from a specific location.
/// - Note: This protocol is likely used to abstract data retrieval from different sources, such as disk directories or network resources.
package protocol VirtualizationDataSet {
  /// Retrieves data associated with a specific key path within the `Paths` type.
  ///
  /// - Parameter name: The key path to the data to retrieve.
  /// - Returns: The retrieved data.
  /// - Throws: An error if data retrieval fails.
  func data(from name: KeyPath<any VirtualizationData.Paths, String>) throws -> Data
}

/// Represents essential data about a virtual machine.
public struct VirtualizationData: Sendable {
  /// The unique identifier of the virtual machine.
  public let machineIdentifier: MachineIdentifier
  /// The hardware model used by the virtual machine.
  public let hardwareModel: HardwareModel
  /// Creates a new `VirtualizationData` instance with the provided machine identifier and hardware model.
  private init(machineIdentifier: MachineIdentifier, hardwareModel: HardwareModel) {
    self.machineIdentifier = machineIdentifier
    self.hardwareModel = hardwareModel
  }
}

public extension VirtualizationData {
  #warning("@leo: help here")
  typealias Paths = URL.Bushel.Paths.VZMac

  /// A private struct representing a directory containing virtual machine data.
  private struct Directory: VirtualizationDataSet {
    /// The URL of the directory containing virtual machine data.
    let url: URL
    #warning("@leo: help here")
    let paths: any Paths

    /// Retrieves data associated with a specific key path within the `Paths` type.
    ///
    /// This method retrieves data for the specified key path from a file located within the directory represented by this `Directory` instance.
    ///
    /// - Parameter name: The key path to the data to retrieve. This key path should correspond to a file name defined within the `Paths` type.
    /// - Returns: The data retrieved from the corresponding file.
    /// - Throws: An error if data retrieval fails (e.g., file not found, permission issues).
    func data(from name: KeyPath<any Paths, String>) throws -> Data {
      let fileURL = url.appendingPathComponent(paths[keyPath: name])
      return try Data(contentsOf: fileURL)
    }
  }

  /// Creates a `VirtualizationData` instance from a provided `VirtualizationDataSet`.
  ///
  /// - Parameters:
  ///   - set: An instance conforming to the `VirtualizationDataSet` protocol that provides access to virtual machine data.
  ///   - plistDecoder: A `PropertyListDecoder` instance used to decode property list data retrieved from the `VirtualizationDataSet`.
  /// - Throws: An error if data retrieval or decoding fails.
  internal init(
    at set: any VirtualizationDataSet,
    using plistDecoder: PropertyListDecoder
  ) throws {
    let machineIdentifierData = try set.data(from: \(any Paths).machineIdentifierFileName)
    let machineIdentifier = try plistDecoder.decode(MachineIdentifier.self, from: machineIdentifierData)

    let hardwareModelData = try set.data(from: \(any Paths).hardwareModelFileName)

    let hardwareModel = try plistDecoder.decode(HardwareModel.self, from: hardwareModelData)
    self.init(machineIdentifier: machineIdentifier, hardwareModel: hardwareModel)
  }

  /// Creates a `VirtualizationData` instance from a data directory URL and a `Paths` instance.
  ///
  /// - Parameters:
  ///   - dataDirectory: The URL of the directory containing virtual machine data.
  ///   - paths: An instance of the `Paths` type, likely used to navigate within the directory structure.
  ///   - plistDecoder: A `PropertyListDecoder` instance used to decode property list data retrieved from the directory.
  /// - Throws: An error if data retrieval or decoding fails.
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
