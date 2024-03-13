//
// DataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

protocol SystemProfileType: Decodable {
  static var dataType: DataType { get }
}

enum DataType: String {
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
    enum Error: Swift.Error {
      case missingRoot
      case missingData
    }

    static func data<T: SystemProfileType>() throws -> [T] {
      let process = Process()
      process.executableURL = .init(filePath: "/usr/sbin/system_profiler")
      process.arguments = [T.dataType.rawValue, "-json"]
      let pipe = Pipe()
      process.standardOutput = pipe
      try process.run()
      guard let data = try pipe.fileHandleForReading.readToEnd() else {
        throw Error.missingData
      }
      guard let dict = try JSONDecoder().decode([String: [T]].self, from: data)[T.dataType.rawValue] else {
        throw Error.missingRoot
      }
      return dict
    }
  }
#endif

extension SPHardwareDataType: SystemProfileType {
  static var dataType: DataType {
    .SPHardwareDataType
  }
}

extension SPNetworkDataType: SystemProfileType {
  static var dataType: DataType {
    .SPNetworkDataType
  }
}
