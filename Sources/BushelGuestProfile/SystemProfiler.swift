//
//  SystemProfiler.swift
//  Sublimation
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

public struct SystemProfiler: Codable, Equatable, Sendable {
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

  public let spAirPortDataType: [SPAirPortDataType]
  public let spApplicationsDataType: [SPSDataType]
  public let spBluetoothDataType: [SPBluetoothDataType]
  public let spDeveloperToolsDataType: [SPDeveloperToolsDataType]
  public let spEthernetDataType: [SPEthernetDataType]
  public let spExtensionsDataType: [SPExtensionsDataType]
  public let spFirewallDataType: [SPFirewallDataType]
  public let spFontsDataType: [SPFontsDataType]
  public let spFrameworksDataType: [SPSDataType]
  public let spHardwareDataType: [SPHardwareDataType]
  public let sPiBridgeDataType: [SPiBridgeDataType]
  public let spInstallHistoryDataType: [SPInstallHistoryDataType]
  public let spInternationalDataType: [SPInternationalDataType]
  public let spLogsDataType: [SPLogsDataType]
  public let spMemoryDataType: [SPMemoryDataType]
  public let spNetworkDataType: [SPNetworkDataType]
  public let spNetworkLocationDataType: [SPNetworkLocationDataType]
  public let spNetworkVolumeDataType: [SPNetworkVolumeDataType]
  public let spPowerDataType: [SPPowerDataType]
  public let spPrefPaneDataType: [SPPrefPaneDataType]
  public let spPrintersDataType: [SPPrintersDataType]
  public let spPrintersSoftwareDataType: [SPPrintersSoftwareDataType]
  public let spRawCameraDataType: [SPRawCameraDataType]
  public let spSmartCardsDataType: [SPSmartCardsDataType]
  public let spSoftwareDataType: [SPSoftwareDataType]
  public let spStorageDataType: [SPStorageDataType]
  public let spSyncServicesDataType: [SPSyncServicesDataType]
  public let spThunderboltDataType: [SPThunderboltDataType]
  public let spUniversalAccessDataType: [SPUniversalAccessDataType]
  public let spusbDataType: [SPUSBDataType]

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
