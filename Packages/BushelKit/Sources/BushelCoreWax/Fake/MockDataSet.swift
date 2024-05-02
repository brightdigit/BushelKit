//
// MockDataSet.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

let hardwareModelFormatString = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>DataRepresentationVersion</key>
  <integer>%i</integer>
  <key>MinimumSupportedOS</key>
  <array>
    <integer>%i</integer>
    <integer>%i</integer>
    <integer>%i</integer>
  </array>
  <key>PlatformVersion</key>
  <integer>%i</integer>
</dict>
</plist>
"""

let machineIdentifierFormatString = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>ECID</key>
  <integer>%llu</integer>
</dict>
</plist>
"""

package struct MockDataSet: VirtualizationDataSet {
  enum Error: Swift.Error {
    case notSupportedKeyPath
    case missingDataForString
  }

  let machineIdentifierData: Data
  let hardwareModelData: Data

  package init(
    machineIdentifier: MachineIdentifier,
    hardwareModel: HardwareModel
  ) throws {
    let hardwareModelString = String(
      format: hardwareModelFormatString,
      hardwareModel.dataRepresentationVersion,
      hardwareModel.minimumSupportedOS.majorVersion,
      hardwareModel.minimumSupportedOS.minorVersion,
      hardwareModel.minimumSupportedOS.patchVersion,
      hardwareModel.platformVersion
    )

    let machineIdentifierString = String(
      format: machineIdentifierFormatString,
      machineIdentifier.ecID
    )

    try self.init(
      machineIdentifierString: machineIdentifierString,
      hardwareModelString: hardwareModelString
    )
  }

  internal init(
    machineIdentifierString: String,
    hardwareModelString: String
  ) throws {
    guard let machineIdentifierData = machineIdentifierString.data(using: .utf8) else {
      throw Error.missingDataForString
    }
    guard let hardwareModelData = hardwareModelString.data(using: .utf8) else {
      throw Error.missingDataForString
    }

    self.init(machineIdentifierData: machineIdentifierData, hardwareModelData: hardwareModelData)
  }

  internal init(
    machineIdentifierData: Data,
    hardwareModelData: Data
  ) {
    self.machineIdentifierData = machineIdentifierData
    self.hardwareModelData = hardwareModelData
  }

  package func data(from name: KeyPath<any BushelCore.VirtualizationData.Paths, String>) throws -> Data {
    switch name {
    case \.hardwareModelFileName:
      hardwareModelData

    case \.machineIdentifierFileName:
      machineIdentifierData

    default:
      throw Error.notSupportedKeyPath
    }
  }
}
