//
//  VZMacOSRestoreImage.swift
//  Sublimation
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

#if canImport(Virtualization) && arch(arm64)
  public import BushelCore

  public import Virtualization

  #warning("Temporary Fix")
  #warning("Remove @unchecked Sendable")
  extension VZMacOSRestoreImage: @unchecked @retroactive Sendable {
    struct OperatingSystem: OperatingSystemInstalled {
      let operatingSystemVersion: OperatingSystemVersion
      let buildVersion: String?
      init(operatingSystemVersion: OperatingSystemVersion, buildVersion: String?) {
        self.operatingSystemVersion = operatingSystemVersion
        self.buildVersion = buildVersion
      }

      init?(operatingSystemVersion: OperatingSystemVersion?, buildVersion: String?) {
        guard let operatingSystemVersion else { return nil }
        self.init(operatingSystemVersion: operatingSystemVersion, buildVersion: buildVersion)
      }
    }

    public var operatingSystem: any OperatingSystemInstalled {
      OperatingSystem(operatingSystemVersion: operatingSystemVersion, buildVersion: buildVersion)
    }

    @available(*, deprecated, message: "Temporary method until Swift 6 migration.")
    public static func unsafeFetchLatestSupported() async throws -> VZMacOSRestoreImage {
      try await withCheckedThrowingContinuation { continuation in
        self.fetchLatestSupported { result in continuation.resume(with: result) }
      }
    }

    @available(*, deprecated, message: "Temporary method until Swift 6 migration.")
    public static func unsafeLoadFromURL(_ url: URL) async throws -> VZMacOSRestoreImage {
      try await withCheckedThrowingContinuation { continuation in
        self.load(from: url) { result in continuation.resume(with: result) }
      }
    }

    func headers(withSession session: URLSession = .shared) async throws -> [AnyHashable: Any] {
      var request = URLRequest(url: url)
      request.httpMethod = "HEAD"
      let (_, response) = try await session.data(for: request)

      guard let response = response as? HTTPURLResponse else {
        throw InvalidResponseError(response, from: url)
      }

      return response.allHeaderFields
    }
  }

#endif