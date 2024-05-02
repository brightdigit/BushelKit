//
// SPiBridgeDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPiBridgeDataType

public struct SPiBridgeDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
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

  // swiftlint:disable:next line_length
  public init(ibridgeBootUUID: String, ibridgeBuild: String, ibridgeExtraBootPolicies: String, ibridgeModelIdentifierTop: String, ibridgeSbBootArgs: String, ibridgeSbCtrr: String, ibridgeSbDeviceMdm: String, ibridgeSbManualMdm: String, ibridgeSbOtherKext: String, ibridgeSbSIP: String, ibridgeSbSsv: String, ibridgeSecureBoot: String) {
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
