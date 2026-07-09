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

/// A signature verifier that determines image signing status using the VirtualBuddy service.
public struct VirtualBuddySigVerifier: SourceSigVerifier {
  /// The identifier of this signature source.
  public let sourceID: String = "virtualbuddy"
  /// The priority applied to signatures produced by this verifier.
  public let priority: SignaturePriority = .always
  private let service: VirtualBuddyService
  private let urlFromSource: @Sendable (SignatureSource) async -> URL?
  /// The virtual machine system this verifier applies to.
  public var id: VMSystemID { .macOS }

  private init(
    service: VirtualBuddyService, urlFromSource: @escaping @Sendable (SignatureSource) async -> URL?
  ) {
    self.service = service
    self.urlFromSource = urlFromSource
  }

  /// Creates a verifier using an explicit API key.
  /// - Parameters:
  ///   - apiKey: The API key used to authenticate with the VirtualBuddy service.
  ///   - decoder: The JSON decoder used to decode service responses.
  ///   - urlSession: The URL session used for network requests. Defaults to the shared session.
  ///   - urlFromSource: A closure resolving a signature source to its image URL.
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

  /// Creates a verifier from a configuration, returning `nil` if no configuration is available.
  /// - Parameters:
  ///   - configuration: The configuration providing the API key.
  ///     Defaults to ``VirtualBuddyConfiguration/main``.
  ///   - decoder: The JSON decoder used to decode service responses.
  ///   - urlSession: The URL session used for network requests. Defaults to the shared session.
  ///   - urlFromSource: A closure resolving a signature source to its image URL.
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

  /// Retrieves the signature for the image associated with a signature source.
  /// - Parameters:
  ///   - source: The signature source identifying the image to verify.
  ///   - timestamp: The timestamp to associate with the verification request.
  /// - Returns: The image signature reported by the VirtualBuddy service.
  /// - Throws: A ``SigVerificationError`` if the source is unsupported or verification fails.
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
