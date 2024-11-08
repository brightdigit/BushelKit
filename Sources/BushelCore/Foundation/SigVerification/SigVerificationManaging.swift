//
//  SigVerificationManaging.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


public protocol SigVerificationManaging: Sendable {
  func resolve(_ id: VMSystemID) -> SigVerifier
}

extension SigVerificationManaging {
  public func isSignatureSigned(from source: SignatureSource, for id: VMSystemID) async throws (SigVerificationError) -> SigVerification {
    try await self.resolve(id).isSignatureSigned(from: source)
  }
}
