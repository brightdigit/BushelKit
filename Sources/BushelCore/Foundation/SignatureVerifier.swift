//
//  SignatureVerifier.swift
//  BushelKit
//
//  Created by Leo Dion on 11/5/24.
//

public import Foundation

public enum SigVerification : Sendable, Codable {
  case unsigned
  case signed
}

extension SigVerification {
  public init (isSigned: Bool) {
    self = isSigned ? .signed : .unsigned
  }
}

public enum SigVerificationError : Error {
  
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
  func isSignatureSigned(from source: SignatureSource) throws (SigVerificationError) -> SigVerification
}

public protocol SigVerificationManaging: Sendable {
  func resolve(_ id: VMSystemID) -> SigVerifier
}

extension SigVerificationManaging {
  public func isSignatureSigned(from source: SignatureSource, for id: VMSystemID) throws (SigVerificationError) -> SigVerification {
    try self.resolve(id).isSignatureSigned(from: source)
  }
}
