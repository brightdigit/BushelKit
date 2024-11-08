//
//  SigVerifier.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


public protocol SigVerifier : Sendable {
  var id: VMSystemID { get }
  func isSignatureSigned(from source: SignatureSource) async throws (SigVerificationError) -> SigVerification
}