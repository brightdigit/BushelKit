//
//  SourceSigVerifier.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//

public import Foundation


public protocol SourceSigVerifier : Sendable {
  var id: VMSystemID { get }
  var sourceID: String { get }
  var priority: SignaturePriority { get }
  func imageSignature(from source: SignatureSource, timestamp : Date) async throws (SigVerificationError) -> ImageSignature
  
}
extension SourceSigVerifier {
  public func imageSignature(from source: SignatureSource) async throws (SigVerificationError) -> ImageSignature {
    try await self.imageSignature(from: source, timestamp: .now)
  }
}
