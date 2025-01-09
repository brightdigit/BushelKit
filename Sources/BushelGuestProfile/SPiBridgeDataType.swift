//
//  SPiBridgeDataType.swift
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

/// Represents the data type for the SPiBridge.
public struct SPiBridgeDataType: Codable, Equatable, Sendable {
  /// The coding keys for the SPiBridgeDataType.
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

  /// The UUID of the ibridge boot.
  public let ibridgeBootUUID: String
  /// The build of the ibridge.
  public let ibridgeBuild: String
  /// The extra boot policies for the ibridge.
  public let ibridgeExtraBootPolicies: String
  /// The top model identifier of the ibridge.
  public let ibridgeModelIdentifierTop: String
  /// The boot arguments for the ibridge secure boot.
  public let ibridgeSbBootArgs: String
  /// The CTRR (Constrained Temporal Root of Trust) setting for the ibridge secure boot.
  public let ibridgeSbCtrr: String
  /// The device MDM (Mobile Device Management) setting for the ibridge secure boot.
  public let ibridgeSbDeviceMdm: String
  /// The manual MDM (Mobile Device Management) setting for the ibridge secure boot.
  public let ibridgeSbManualMdm: String
  /// The other kernel extensions setting for the ibridge secure boot.
  public let ibridgeSbOtherKext: String
  /// The System Integrity Protection (SIP) setting for the ibridge secure boot.
  public let ibridgeSbSIP: String
  /// The Secure System Verification (SSV) setting for the ibridge secure boot.
  public let ibridgeSbSsv: String
  /// The secure boot setting for the ibridge.
  public let ibridgeSecureBoot: String

  /// Initializes an instance of `SPiBridgeDataType` with the given parameters.
  /// - Parameters:
  ///   - ibridgeBootUUID: The UUID of the ibridge boot.
  ///   - ibridgeBuild: The build of the ibridge.
  ///   - ibridgeExtraBootPolicies: The extra boot policies for the ibridge.
  ///   - ibridgeModelIdentifierTop: The top model identifier of the ibridge.
  ///   - ibridgeSbBootArgs: The boot arguments for the ibridge secure boot.
  ///   - ibridgeSbCtrr: The CTRR (Constrained Temporal Root of Trust) setting for the ibridge secure boot.
  ///   - ibridgeSbDeviceMdm: The device MDM (Mobile Device Management) setting for the ibridge secure boot.
  ///   - ibridgeSbManualMdm: The manual MDM (Mobile Device Management) setting for the ibridge secure boot.
  ///   - ibridgeSbOtherKext: The other kernel extensions setting for the ibridge secure boot.
  ///   - ibridgeSbSIP: The System Integrity Protection (SIP) setting for the ibridge secure boot.
  ///   - ibridgeSbSsv: The Secure System Verification (SSV) setting for the ibridge secure boot.
  ///   - ibridgeSecureBoot: The secure boot setting for the ibridge.
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
