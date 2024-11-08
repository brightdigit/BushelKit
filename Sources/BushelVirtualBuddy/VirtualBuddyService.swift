//
//  VirtualBuddyService.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//

import Foundation



internal struct VirtualBuddyService {
  private init(decoder: JSONDecoder, urlSession: URLSession, baseURLComponents: URLComponents) {
    self.decoder = decoder
    self.urlSession = urlSession
    self.baseURLComponents = baseURLComponents
  }
  
  internal init(apiKey: String, decoder: JSONDecoder, urlSession: URLSession = .shared) {
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
    if ipsw.scheme == "file" {
      return nil
    }
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
