//
//  VirtualBuddySigVerifier.swift
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

public import BushelFoundation
internal import BushelMacOSCore
public import Foundation

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif

public struct VirtualBuddySigVerifier: SourceSigVerifier {
  public let sourceID: String = "virtualbuddy"
  public let priority: SignaturePriority = .always
  private let service: VirtualBuddyService
  private let urlFromSource: @Sendable (SignatureSource) async -> URL?
  public var id: VMSystemID { .macOS }

  private init(
    service: VirtualBuddyService, urlFromSource: @escaping @Sendable (SignatureSource) async -> URL?
  ) {
    self.service = service
    self.urlFromSource = urlFromSource
  }

  public init(
    apiKey: String,
    decoder: JSONDecoder,
    urlSession: URLSession = .shared,
    urlFromSource: @escaping @Sendable (SignatureSource) async -> URL?
  ) {
    self.init(
      service: .init(apiKey: apiKey, decoder: decoder, urlSession: urlSession),
      urlFromSource: urlFromSource
    )
  }

  public init?(
    configuration: VirtualBuddyConfiguration? = .main,
    decoder: JSONDecoder,
    urlSession: URLSession = .shared,
    urlFromSource: @escaping @Sendable (SignatureSource) async -> URL?
  ) {
    assert(configuration != nil, "VirtualBuddyConfiguration is nil")
    guard let configuration else {
      return nil
    }
    self.init(
      apiKey: configuration.apiKey,
      decoder: decoder,
      urlSession: urlSession,
      urlFromSource: urlFromSource
    )
  }

  public func imageSignature(
    from source: SignatureSource,
    timestamp: Date
  ) async throws(SigVerificationError) -> ImageSignature {
    guard let url = await urlFromSource(source) else {
      throw SigVerificationError.unsupportedSource
    }
    let sig: VirtualBuddySig
    do {
      sig = try await service.status(ipsw: url)
    } catch .unknownError(let error) {
      throw .unknownError(error)
    } catch {
      throw .internalError(error)
    }
    return ImageSignature(
      sourceID: self.sourceID,
      signatureID: url.standardized.description,
      vmSystemID: .macOS,
      operatingSystemVersion: sig.version,
      buildVersion: sig.build,
      verification: .init(isSigned: sig.isSigned),
      priority: self.priority,
      timestamp: .now
    )
  }
}
