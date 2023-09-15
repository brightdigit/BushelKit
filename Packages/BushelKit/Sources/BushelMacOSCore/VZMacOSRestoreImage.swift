//
// VZMacOSRestoreImage.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import Virtualization

  public extension VZMacOSRestoreImage {
    static func fetchLatestSupported() async throws -> VZMacOSRestoreImage {
      try await withCheckedThrowingContinuation { continuation in
        self.fetchLatestSupported { result in
          continuation.resume(with: result)
        }
      }
    }

    static func loadFromURL(_ url: URL) async throws -> VZMacOSRestoreImage {
      try await withCheckedThrowingContinuation { continuation in
        self.load(from: url, completionHandler: continuation.resume(with:))
      }
    }

    internal func headers(
      withSession session: URLSession = .shared
    ) async throws -> [AnyHashable: Any] {
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