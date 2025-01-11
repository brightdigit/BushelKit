//
//  SystemProfiler.swift
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

public import Foundation

/// A struct representing the System Profiler data.
public struct SystemProfiler: Codable, Equatable, Sendable {
  /// Coding keys for the System Profiler data.
  public enum CodingKeys: String, CodingKey {
    case spAirPortDataType = "SPAirPortDataType"
    case spApplicationsDataType = "SPApplicationsDataType"
    case spBluetoothDataType = "SPBluetoothDataType"
    case spDeveloperToolsDataType = "SPDeveloperToolsDataType"
    case spEthernetDataType = "SPEthernetDataType"
    case spExtensionsDataType = "SPExtensionsDataType"
    case spFirewallDataType = "SPFirewallDataType"
    case spFontsDataType = "SPFontsDataType"
    case spFrameworksDataType = "SPFrameworksDataType"
    case spHardwareDataType = "SPHardwareDataType"
    case sPiBridgeDataType = "SPiBridgeDataType"
    case spInstallHistoryDataType = "SPInstallHistoryDataType"
    case spInternationalDataType = "SPInternationalDataType"
    case spLogsDataType = "SPLogsDataType"
    case spMemoryDataType = "SPMemoryDataType"
    case spNetworkDataType = "SPNetworkDataType"
    case spNetworkLocationDataType = "SPNetworkLocationDataType"
    case spNetworkVolumeDataType = "SPNetworkVolumeDataType"
    case spPowerDataType = "SPPowerDataType"
    case spPrefPaneDataType = "SPPrefPaneDataType"
    case spPrintersDataType = "SPPrintersDataType"
    case spPrintersSoftwareDataType = "SPPrintersSoftwareDataType"
    case spRawCameraDataType = "SPRawCameraDataType"
    case spSmartCardsDataType = "SPSmartCardsDataType"
    case spSoftwareDataType = "SPSoftwareDataType"
    case spStorageDataType = "SPStorageDataType"
    case spSyncServicesDataType = "SPSyncServicesDataType"
    case spThunderboltDataType = "SPThunderboltDataType"
    case spUniversalAccessDataType = "SPUniversalAccessDataType"
    case spusbDataType = "SPUSBDataType"
  }

  /// The AirPort data.
  public let spAirPortDataType: [SPAirPortDataType]
  /// The applications data.
  public let spApplicationsDataType: [SPSDataType]
  /// The Bluetooth data.
  public let spBluetoothDataType: [SPBluetoothDataType]
  /// The developer tools data.
  public let spDeveloperToolsDataType: [SPDeveloperToolsDataType]
  /// The Ethernet data.
  public let spEthernetDataType: [SPEthernetDataType]
  /// The extensions data.
  public let spExtensionsDataType: [SPExtensionsDataType]
  /// The firewall data.
  public let spFirewallDataType: [SPFirewallDataType]
  /// The fonts data.
  public let spFontsDataType: [SPFontsDataType]
  /// The frameworks data.
  public let spFrameworksDataType: [SPSDataType]
  /// The hardware data.
  public let spHardwareDataType: [SPHardwareDataType]
  /// The iBridge data.
  public let sPiBridgeDataType: [SPiBridgeDataType]
  /// The install history data.
  public let spInstallHistoryDataType: [SPInstallHistoryDataType]
  /// The international data.
  public let spInternationalDataType: [SPInternationalDataType]
  /// The logs data.
  public let spLogsDataType: [SPLogsDataType]
  /// The memory data.
  public let spMemoryDataType: [SPMemoryDataType]
  /// The network data.
  public let spNetworkDataType: [SPNetworkDataType]
  /// The network location data.
  public let spNetworkLocationDataType: [SPNetworkLocationDataType]
  /// The network volume data.
  public let spNetworkVolumeDataType: [SPNetworkVolumeDataType]
  /// The power data.
  public let spPowerDataType: [SPPowerDataType]
  /// The preference pane data.
  public let spPrefPaneDataType: [SPPrefPaneDataType]
  /// The printers data.
  public let spPrintersDataType: [SPPrintersDataType]
  /// The printers software data.
  public let spPrintersSoftwareDataType: [SPPrintersSoftwareDataType]
  /// The raw camera data.
  public let spRawCameraDataType: [SPRawCameraDataType]
  /// The smart cards data.
  public let spSmartCardsDataType: [SPSmartCardsDataType]
  /// The software data.
  public let spSoftwareDataType: [SPSoftwareDataType]
  /// The storage data.
  public let spStorageDataType: [SPStorageDataType]
  /// The sync services data.
  public let spSyncServicesDataType: [SPSyncServicesDataType]
  /// The Thunderbolt data.
  public let spThunderboltDataType: [SPThunderboltDataType]
  /// The universal access data.
  public let spUniversalAccessDataType: [SPUniversalAccessDataType]
  /// The USB data.
  public let spusbDataType: [SPUSBDataType]

  /// Initializes a `SystemProfiler` instance with the provided data.
  /// - Parameters:
  ///   - spAirPortDataType: The AirPort data.
  ///   - spApplicationsDataType: The applications data.
  ///   - spBluetoothDataType: The Bluetooth data.
  ///   - spDeveloperToolsDataType: The developer tools data.
  ///   - spEthernetDataType: The Ethernet data.
  ///   - spExtensionsDataType: The extensions data.
  ///   - spFirewallDataType: The firewall data.
  ///   - spFontsDataType: The fonts data.
  ///   - spFrameworksDataType: The frameworks data.
  ///   - spHardwareDataType: The hardware data.
  ///   - sPiBridgeDataType: The iBridge data.
  ///   - spInstallHistoryDataType: The install history data.
  ///   - spInternationalDataType: The international data.
  ///   - spLogsDataType: The logs data.
  ///   - spMemoryDataType: The memory data.
  ///   - spNetworkDataType: The network data.
  ///   - spNetworkLocationDataType: The network location data.
  ///   - spNetworkVolumeDataType: The network volume data.
  ///   - spPowerDataType: The power data.
  ///   - spPrefPaneDataType: The preference pane data.
  ///   - spPrintersDataType: The printers data.
  ///   - spPrintersSoftwareDataType: The printers software data.
  ///   - spRawCameraDataType: The raw camera data.
  ///   - spSmartCardsDataType: The smart cards data.
  ///   - spSoftwareDataType: The software data.
  ///   - spStorageDataType: The storage data.
  ///   - spSyncServicesDataType: The sync services data.
  ///   - spThunderboltDataType: The Thunderbolt data.
  ///   - spUniversalAccessDataType: The universal access data.
  public init(
    spAirPortDataType: [SPAirPortDataType],
    spApplicationsDataType: [SPSDataType],
    spBluetoothDataType: [SPBluetoothDataType],
    spDeveloperToolsDataType: [SPDeveloperToolsDataType],
    spEthernetDataType: [SPEthernetDataType],
    spExtensionsDataType: [SPExtensionsDataType],
    spFirewallDataType: [SPFirewallDataType],
    spFontsDataType: [SPFontsDataType],
    spFrameworksDataType: [SPSDataType],
    spHardwareDataType: [SPHardwareDataType],
    sPiBridgeDataType: [SPiBridgeDataType],
    spInstallHistoryDataType: [SPInstallHistoryDataType],
    spInternationalDataType: [SPInternationalDataType],
    spLogsDataType: [SPLogsDataType],
    spMemoryDataType: [SPMemoryDataType],
    spNetworkDataType: [SPNetworkDataType],
    spNetworkLocationDataType: [SPNetworkLocationDataType],
    spNetworkVolumeDataType: [SPNetworkVolumeDataType],
    spPowerDataType: [SPPowerDataType],
    spPrefPaneDataType: [SPPrefPaneDataType],
    spPrintersDataType: [SPPrintersDataType],
    spPrintersSoftwareDataType: [SPPrintersSoftwareDataType],
    spRawCameraDataType: [SPRawCameraDataType],
    spSmartCardsDataType: [SPSmartCardsDataType],
    spSoftwareDataType: [SPSoftwareDataType],
    spStorageDataType: [SPStorageDataType],
    spSyncServicesDataType: [SPSyncServicesDataType],
    spThunderboltDataType: [SPThunderboltDataType],
    spUniversalAccessDataType: [SPUniversalAccessDataType],
    spusbDataType: [SPUSBDataType]
  ) {
    self.spAirPortDataType = spAirPortDataType
    self.spApplicationsDataType = spApplicationsDataType
    self.spBluetoothDataType = spBluetoothDataType
    self.spDeveloperToolsDataType = spDeveloperToolsDataType
    self.spEthernetDataType = spEthernetDataType
    self.spExtensionsDataType = spExtensionsDataType
    self.spFirewallDataType = spFirewallDataType
    self.spFontsDataType = spFontsDataType
    self.spFrameworksDataType = spFrameworksDataType
    self.spHardwareDataType = spHardwareDataType
    self.sPiBridgeDataType = sPiBridgeDataType
    self.spInstallHistoryDataType = spInstallHistoryDataType
    self.spInternationalDataType = spInternationalDataType
    self.spLogsDataType = spLogsDataType
    self.spMemoryDataType = spMemoryDataType
    self.spNetworkDataType = spNetworkDataType
    self.spNetworkLocationDataType = spNetworkLocationDataType
    self.spNetworkVolumeDataType = spNetworkVolumeDataType
    self.spPowerDataType = spPowerDataType
    self.spPrefPaneDataType = spPrefPaneDataType
    self.spPrintersDataType = spPrintersDataType
    self.spPrintersSoftwareDataType = spPrintersSoftwareDataType
    self.spRawCameraDataType = spRawCameraDataType
    self.spSmartCardsDataType = spSmartCardsDataType
    self.spSoftwareDataType = spSoftwareDataType
    self.spStorageDataType = spStorageDataType
    self.spSyncServicesDataType = spSyncServicesDataType
    self.spThunderboltDataType = spThunderboltDataType
    self.spUniversalAccessDataType = spUniversalAccessDataType
    self.spusbDataType = spusbDataType
  }
}
