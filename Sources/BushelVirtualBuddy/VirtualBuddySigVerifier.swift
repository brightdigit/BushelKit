//
//  VirtualBuddySigVerifier.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//

public import Foundation
public import BushelCore
import BushelMacOSCore



public struct VirtualBuddySigVerifier : SourceSigVerifier {
  public let sourceID: String = "virtualbuddy"
  
  public let priority: BushelCore.SignaturePriority = .always
  
  public func imageSignature(
    from source: SignatureSource,
    timestamp: Date
  ) async throws(SigVerificationError) -> ImageSignature {
    guard let url = await urlFromSource(source) else {
      throw SigVerificationError.unsupportedSource
    }
    let sig : VirtualBuddySig
    do {
      sig = try await service.status(ipsw: url)
    } catch {
      throw .internalError(error)
    }
    return ImageSignature(sourceID: self.sourceID, signatureID: url.standardized.description, vmSystemID: .macOS, operatingSystemVersion: sig.version, buildVersion: sig.build, verification: .init(isSigned: sig.isSigned), priority: self.priority, timestamp: .now)
  }
  
  private init(service: VirtualBuddyService, urlFromSource: @escaping @Sendable (SignatureSource) async-> URL?) {
    self.service = service
    self.urlFromSource = urlFromSource
  }
  
  public init(apiKey: String, decoder: JSONDecoder, urlSession: URLSession = .shared, urlFromSource: @escaping @Sendable (SignatureSource) async -> URL?)  {
    self.init(
      service: .init(apiKey: apiKey, decoder: decoder, urlSession: urlSession),
      urlFromSource: urlFromSource
    )
  }
  
  public init?(configuration: VirtualBuddyConfiguration? = .main, decoder: JSONDecoder, urlSession: URLSession = .shared, urlFromSource: @escaping @Sendable (SignatureSource) async -> URL?)  {
    assert(configuration != nil, "VirtualBuddyConfiguration is nil")
    guard let configuration else { return nil }
    self.init(apiKey: configuration.apiKey, decoder: decoder, urlSession: urlSession, urlFromSource: urlFromSource)
  }
  
  //URL(string: "GET https://tss.virtualbuddy.app/v1/status?apiKey=<your api key>&ipsw=<IPSW URL>")!
  private let service : VirtualBuddyService
  private let urlFromSource: @Sendable (SignatureSource) async -> URL?
  public var id: VMSystemID { .macOS }
  
  public func isSignatureSigned(from source: SignatureSource) async throws (SigVerificationError) -> SigVerification {
    guard let url = await urlFromSource(source) else {
      throw SigVerificationError.unsupportedSource
    }
    let isSigned : Bool
    do {
      isSigned = try await service.status(ipsw: url).isSigned
    } catch {
      throw .internalError(error)
    }
    return .init(isSigned: isSigned)
  }
}
