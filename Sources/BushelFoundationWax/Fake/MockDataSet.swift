//
//  MockDataSet.swift
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

package import BushelFoundation
package import Foundation

private let hardwareModelFormatString = """
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

private let machineIdentifierFormatString = """
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
  internal enum Error: Swift.Error {
    case notSupportedKeyPath
    case missingDataForString
  }

  internal let machineIdentifierData: Data
  internal let hardwareModelData: Data

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

  package func data(from name: KeyPath<any VirtualizationData.Paths, String>) throws
    -> Data
  {
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
