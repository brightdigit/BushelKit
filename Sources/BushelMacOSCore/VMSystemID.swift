//
//  VMSystemID.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

public import BushelCore
public import Foundation

extension VMSystemID {
  public static let macOS: VMSystemID = "macOSApple"
}

private enum VirtualBuddyError : Error {
  case unsupportedURL(URL)
  case networkError(Error)
  case decodingError(Error)
}

private struct VirtualBuddySig : Codable {
  let uuid: UUID
  let version: OperatingSystemVersion
  let build: String
  let code: Int
  let message: String
  let isSigned: Bool
}

private struct VirtualBuddyService {
  private init(decoder: JSONDecoder, urlSession: URLSession, baseURLComponents: URLComponents) {
    self.decoder = decoder
    self.urlSession = urlSession
    self.baseURLComponents = baseURLComponents
  }
  
  fileprivate init(apiKey: String, decoder: JSONDecoder, urlSession: URLSession = .shared) {
    self.init(decoder: decoder, urlSession: urlSession, baseURLComponents: Self.baseURLComponents(apiKey:  apiKey))
  }
  
  //let apiKey : String
  let decoder: JSONDecoder
  let urlSession: URLSession
  let baseURLComponents : URLComponents
  static let baseURLComponents = URLComponents(string: "https://tss.virtualbuddy.app/v1/status")!
  
  static func baseURLComponents(apiKey: String) -> URLComponents {
    var components = Self.baseURLComponents
    components.queryItems = [.init(name: "apiKey", value: apiKey)]
    return components
  }
  
  private func endpointURL(ipsw: URL) -> URL? {
    var endpointComponents = self.baseURLComponents
    assert(endpointComponents.queryItems != nil)
    endpointComponents.queryItems?.append(.init(name: "ipsw", value: ipsw.absoluteString))
    assert(endpointComponents.url != nil)
    return endpointComponents.url
  }
  
  public func status (ipsw: URL) async throws(VirtualBuddyError) -> VirtualBuddySig {
#warning("Handle network connection error")
    guard let endpointURL = endpointURL(ipsw: ipsw) else {
      throw .unsupportedURL(ipsw)
    }
    let data : Data
    // let response: URLResponse
    do {
      (data, _) = try await urlSession.data(from: endpointURL)
    } catch {
      throw .networkError(error)
    }
    do {
      return try decoder.decode(VirtualBuddySig.self, from: data)
    } catch {
      throw .decodingError(error)
    }
  }
}

public struct VirtualBuddySigVerifier : SourceSigVerifier {
  public let sourceID: String = "virtualbuddy"
  
  public let priority: BushelCore.SignaturePriority = .always
  
  public func imageSignature(from source: SignatureSource, timestamp: Date) async throws(SigVerificationError) -> ImageSignature {
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
//  public func metadata(from source: BushelCore.SignatureSource) async throws(BushelCore.SigVerificationError) -> BushelCore.SignatureMetadata {
//    <#code#>
//  }
//  
  private init(service: VirtualBuddyService, urlFromSource: @escaping @Sendable (SignatureSource) async-> URL?) {
    self.service = service
    self.urlFromSource = urlFromSource
  }
  
  public init(apiKey: String, decoder: JSONDecoder, urlSession: URLSession = .shared, urlFromSource: @escaping @Sendable (SignatureSource) -> URL?)  {
    self.init(
      service: .init(apiKey: apiKey, decoder: decoder, urlSession: urlSession),
      urlFromSource: urlFromSource
    )
  }
  
  public init?(configuration: VirtualBuddyConfiguration? = .main, decoder: JSONDecoder, urlSession: URLSession = .shared, urlFromSource: @escaping @Sendable (SignatureSource) -> URL?)  {
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

public struct VirtualBuddyConfiguration: Sendable {
  enum Keys: String {
    case virtualBuddy = "VirtualBuddy"
    case apiKey = "APIKey"
  }

  public static let main: VirtualBuddyConfiguration? = .init()
  public let apiKey: String
}

extension VirtualBuddyConfiguration {
  public init?(bundle: Bundle = .main) {
    guard let dictionary = bundle.object(
      forInfoDictionaryKey: Keys.virtualBuddy.rawValue
    ) as? [String: String] else {
      return nil
    }

    guard let apiKey = dictionary[Keys.apiKey.rawValue] else {
      return nil
    }

    self.init(apiKey: apiKey)
  }
}
