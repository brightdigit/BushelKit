//
//  DataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

internal import Foundation

/// A protocol that defines a type that can be used to retrieve system profile data.
public protocol SystemProfileType: Decodable {
  /// The data type that the system profile data represents.
  static var dataType: DataType { get }
}

/// An enumeration representing the different types of system profile data.
/// swift-format-ignore: AlwaysUseLowerCamelCase
public enum DataType: String {
  case SPParallelATADataType
  case SPUniversalAccessDataType
  case SPSecureElementDataType
  case SPApplicationsDataType
  case SPAudioDataType
  case SPBluetoothDataType
  case SPCameraDataType
  case SPCardReaderDataType
  case SPiBridgeDataType
  case SPDeveloperToolsDataType
  case SPDiagnosticsDataType
  case SPDisabledSoftwareDataType
  case SPDiscBurningDataType
  case SPEthernetDataType
  case SPExtensionsDataType
  case SPFibreChannelDataType
  case SPFireWireDataType
  case SPFirewallDataType
  case SPFontsDataType
  case SPFrameworksDataType
  case SPDisplaysDataType
  case SPHardwareDataType
  case SPInstallHistoryDataType
  case SPInternationalDataType
  case SPLegacySoftwareDataType
  case SPNetworkLocationDataType
  case SPLogsDataType
  case SPManagedClientDataType
  case SPMemoryDataType
  case SPNVMeDataType
  case SPNetworkDataType
  case SPPCIDataType
  case SPParallelSCSIDataType
  case SPPowerDataType
  case SPPrefPaneDataType
  case SPPrintersSoftwareDataType
  case SPPrintersDataType
  case SPConfigurationProfileDataType
  case SPRawCameraDataType
  case SPSASDataType
  case SPSerialATADataType
  case SPSPIDataType
  case SPSmartCardsDataType
  case SPSoftwareDataType
  case SPStartupItemDataType
  case SPStorageDataType
  case SPSyncServicesDataType
  case SPThunderboltDataType
  case SPUSBDataType
  case SPNetworkVolumeDataType
  case SPWWANDataType
  case SPAirPortDataType
}

// let hardware: SPHardwareDataType? = try SystemProfiler.data().first
// dump(hardware!)
//
// let network: SPNetworkDataType? = try SystemProfiler.data().first
// dump(network!)
//                            guard let res = process(
// path: "/usr/sbin/system_profiler", arguments: ["SPMemoryDataType", "-json"]) else {
//                            return nil
//                        }")

#if os(macOS)
  extension SystemProfiler {
    /// Errors that can occur when retrieving system profile data.
    public enum Error: Swift.Error {
      case missingRoot
      case missingData
    }

    /// Retrieves system profile data of the specified type.
    ///
    /// - Returns: An array of system profile data of the specified type.
    /// - Throws: `Error.missingRoot` if the root object is missing from the JSON data,
    ///           `Error.missingData` if the data is missing.
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public static func data<T: SystemProfileType>() throws -> [T] {
      let process = Process()
      process.executableURL = .init(filePath: "/usr/sbin/system_profiler")
      process.arguments = [T.dataType.rawValue, "-json"]
      let pipe = Pipe()
      process.standardOutput = pipe
      try process.run()
      guard let data = try pipe.fileHandleForReading.readToEnd() else {
        throw Error.missingData
      }
      guard let dict = try JSONDecoder().decode([String: [T]].self, from: data)[T.dataType.rawValue]
      else {
        throw Error.missingRoot
      }
      return dict
    }
  }
#endif

/// A system profile data type that represents hardware information.
extension SPHardwareDataType: SystemProfileType {
  public static var dataType: DataType {
    .SPHardwareDataType
  }
}

/// A system profile data type that represents network information.
extension SPNetworkDataType: SystemProfileType {
  public static var dataType: DataType {
    .SPNetworkDataType
  }
}
