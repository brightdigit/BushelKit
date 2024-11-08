//
//  SignatureVerifier.swift
//  BushelKit
//
//  Created by Leo Dion on 11/5/24.
//

public import Foundation





public struct ImageSignature : Sendable {
  public init(
    sourceID: String,
          signatureID: String,
    vmSystemID: VMSystemID,
    operatingSystemVersion: OperatingSystemVersion,
    buildVersion: String?,
    verification: SigVerification,
    priority: SignaturePriority,
    timestamp: Date
  ) {
    self.sourceID = sourceID
    self.signatureID =       signatureID
    self.vmSystemID = vmSystemID
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
    self.priority = priority
    self.verification = verification
    self.timestamp = timestamp
  }
  
  public let sourceID: String
  public let signatureID: String
  public let vmSystemID: VMSystemID
  public let operatingSystemVersion: OperatingSystemVersion
  public let buildVersion: String?
  public let verification: SigVerification
  public let priority: SignaturePriority
  public let timestamp: Date
  public var buildID : String {
    return operatingSystemVersion.id(buildVersion: self.buildVersion)
  }
}

