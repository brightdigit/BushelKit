//
//  SignatureVerifier.swift
//  BushelKit
//
//  Created by Leo Dion on 11/5/24.
//

public import Foundation

public enum SigVerification : Sendable, Codable, CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .signed: return "Signed"
    case .unsigned: return "Unsigned"
    }
  }
  
  case unsigned
  case signed
}

extension SigVerification {
  public init (isSigned: Bool) {
    self = isSigned ? .signed : .unsigned
  }
}

public enum SigVerificationError : Error {
  case unsupportedSource
  case internalError(Error)
}

public enum SignatureSource {
  case hubID(String)
}

extension SignatureSource {
  public static func url(_ url: URL) -> Self {
    .hubID(url.standardized.description)
  }
}

public protocol SigVerifier : Sendable {
  var id: VMSystemID { get }
  func isSignatureSigned(from source: SignatureSource) async throws (SigVerificationError) -> SigVerification
}



public protocol SigVerificationManaging: Sendable {
  func resolve(_ id: VMSystemID) -> SigVerifier
}

extension SigVerificationManaging {
  public func isSignatureSigned(from source: SignatureSource, for id: VMSystemID) async throws (SigVerificationError) -> SigVerification {
    try await self.resolve(id).isSignatureSigned(from: source)
  }
}

public enum SignaturePriority: Int, Codable, CaseIterable, Sendable {
  case never = 0
  case always = 2147483647
}

public struct ImageSignature : Sendable {
  public init(
    metadataID: String,
    sourceID: String,
    hubID: String,
    vmSystemID: VMSystemID,
    operatingSystemVersion: OperatingSystemVersion,
    buildVersion: String?,
    verification: SigVerification,
    priority: SignaturePriority,
    timestamp: Date
  ) {
    self.metadataID = metadataID
    self.sourceID = sourceID
    self.hubID = hubID
    self.vmSystemID = vmSystemID
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
    self.priority = priority
    self.verification = verification
    self.timestamp = timestamp
  }
  
  @available(*, deprecated, message: "Fix ID")
  public let metadataID: String
  public let sourceID: String
  @available(*, deprecated, message: "Fix ID")
  public let hubID: String
  public let vmSystemID: VMSystemID
  public let operatingSystemVersion: OperatingSystemVersion
  public let buildVersion: String?
  public let verification: SigVerification
  public let priority: SignaturePriority
  public let timestamp: Date
  public var id : String {
#warning("Make method on OS")
    return [operatingSystemVersion.description, buildVersion ?? ""].joined(separator: ":")
  }
}
