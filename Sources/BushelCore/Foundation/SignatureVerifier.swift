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
  case notFound
}

public enum SignatureSource : Sendable {
  case signatureID(String)
}

extension SignatureSource {
  public static func url(_ url: URL) -> Self {
    .signatureID(url.standardized.description)
  }
  
   
}

public struct SignatureMetadata : Sendable, Codable {
  public let signatureID: String
  public let operatingSystemVersion : OperatingSystemVersion
  public let buildVersion: String?
}

public protocol SourceSigVerifier : Sendable {
  var id: VMSystemID { get }
  var sourceID: String { get }
  var priority: SignaturePriority { get }
  func imageSignature(from source: SignatureSource, timestamp : Date) async throws (SigVerificationError) -> ImageSignature
  //func metadata(from source: SignatureSource) async throws (SigVerificationError) -> SignatureMetadata
  //func signatureID(from source: SignatureSource) -> String
  
}

extension SourceSigVerifier {
  public func imageSignature(from source: SignatureSource) async throws (SigVerificationError) -> ImageSignature {
    try await self.imageSignature(from: source, timestamp: .now)
  }
}

//extension SourceSigVerifier {
//  public func imageSignature(from source: SignatureSource, timestamp : Date = .now) async throws (SigVerificationError) -> ImageSignature {
//    let metadata = try await metadata(from: source)
//    let verification = try await isSignatureSigned(from: source)
//    return .init(
//      sourceID: self.sourceID,
//      signatureID: metadata.signatureID,
//      vmSystemID: self.id,
//      operatingSystemVersion: metadata.operatingSystemVersion,
//      buildVersion: metadata.buildVersion,
//      verification: verification,
//      priority: self.priority,
//      timestamp: timestamp
//    )
//  }
//}
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
  case never = -2147483648
  case medium = 0
  case always = 2147483647
}

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
  public var id : String {
#warning("Make method on OS")
    return [operatingSystemVersion.description, buildVersion ?? ""].joined(separator: ":")
  }
}

