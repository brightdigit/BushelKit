//
//  SPiBridgeDataType.swift
//  BushelKit
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

// MARK: - SPiBridgeDataType

public struct SPiBridgeDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case ibridgeBootUUID = "ibridge_boot_uuid"
    case ibridgeBuild = "ibridge_build"
    case ibridgeExtraBootPolicies = "ibridge_extra_boot_policies"
    case ibridgeModelIdentifierTop = "ibridge_model_identifier_top"
    case ibridgeSbBootArgs = "ibridge_sb_boot_args"
    case ibridgeSbCtrr = "ibridge_sb_ctrr"
    case ibridgeSbDeviceMdm = "ibridge_sb_device_mdm"
    case ibridgeSbManualMdm = "ibridge_sb_manual_mdm"
    case ibridgeSbOtherKext = "ibridge_sb_other_kext"
    case ibridgeSbSIP = "ibridge_sb_sip"
    case ibridgeSbSsv = "ibridge_sb_ssv"
    case ibridgeSecureBoot = "ibridge_secure_boot"
  }

  public let ibridgeBootUUID: String
  public let ibridgeBuild: String
  public let ibridgeExtraBootPolicies: String
  public let ibridgeModelIdentifierTop: String
  public let ibridgeSbBootArgs: String
  public let ibridgeSbCtrr: String
  public let ibridgeSbDeviceMdm: String
  public let ibridgeSbManualMdm: String
  public let ibridgeSbOtherKext: String
  public let ibridgeSbSIP: String
  public let ibridgeSbSsv: String
  public let ibridgeSecureBoot: String

  public init(
    ibridgeBootUUID: String,
    ibridgeBuild: String,
    ibridgeExtraBootPolicies: String,
    ibridgeModelIdentifierTop: String,
    ibridgeSbBootArgs: String,
    ibridgeSbCtrr: String,
    ibridgeSbDeviceMdm: String,
    ibridgeSbManualMdm: String,
    ibridgeSbOtherKext: String,
    ibridgeSbSIP: String,
    ibridgeSbSsv: String,
    ibridgeSecureBoot: String
  ) {
    self.ibridgeBootUUID = ibridgeBootUUID
    self.ibridgeBuild = ibridgeBuild
    self.ibridgeExtraBootPolicies = ibridgeExtraBootPolicies
    self.ibridgeModelIdentifierTop = ibridgeModelIdentifierTop
    self.ibridgeSbBootArgs = ibridgeSbBootArgs
    self.ibridgeSbCtrr = ibridgeSbCtrr
    self.ibridgeSbDeviceMdm = ibridgeSbDeviceMdm
    self.ibridgeSbManualMdm = ibridgeSbManualMdm
    self.ibridgeSbOtherKext = ibridgeSbOtherKext
    self.ibridgeSbSIP = ibridgeSbSIP
    self.ibridgeSbSsv = ibridgeSbSsv
    self.ibridgeSecureBoot = ibridgeSecureBoot
  }
}
