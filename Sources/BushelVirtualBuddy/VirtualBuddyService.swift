//
//  VirtualBuddyService.swift
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

internal import Foundation

#if canImport(FoundationNetworking)
  internal import FoundationNetworking
#endif

internal struct VirtualBuddyService {
  // swiftlint:disable force_unwrapping
  internal static let baseURLComponents = URLComponents(
    string: "https://tss.virtualbuddy.app/v1/status"
  )!
  // swiftlint:enable force_unwrapping

  private let decoder: JSONDecoder
  private let urlSession: URLSession
  private let baseURLComponents: URLComponents

  private init(decoder: JSONDecoder, urlSession: URLSession, baseURLComponents: URLComponents) {
    self.decoder = decoder
    self.urlSession = urlSession
    self.baseURLComponents = baseURLComponents
  }

  internal init(apiKey: String, decoder: JSONDecoder, urlSession: URLSession = .shared) {
    self.init(
      decoder: decoder,
      urlSession: urlSession,
      baseURLComponents: Self.baseURLComponents(apiKey: apiKey)
    )
  }

  private static func baseURLComponents(apiKey: String) -> URLComponents {
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

  internal func status(ipsw: URL) async throws(VirtualBuddyError) -> VirtualBuddySig {
    guard let endpointURL = endpointURL(ipsw: ipsw) else {
      throw .unsupportedURL(ipsw)
    }
    let data: Data
    do {
      (data, _) = try await urlSession.data(from: endpointURL)
    } catch let error as URLError {
      throw .networkError(error)
    } catch {
      throw .unknownError(error)
    }
    do {
      return try decoder.decode(VirtualBuddySig.self, from: data)
    } catch let error as DecodingError {
      throw .decodingError(error)
    } catch {
      throw .unknownError(error)
    }
  }
}
