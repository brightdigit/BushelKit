//
// VZMacOSRestoreImage.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import BushelMachine
import Combine
import Virtualization

extension VZMacOSRestoreImage {
  var isImageSupported: Bool {
    #if swift(>=5.7)
      if #available(macOS 13.0, *) {
        return self.isSupported
      } else {
        return mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported == true
      }
    #else
      return mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported == true
    #endif
  }
}

extension VZMacOSRestoreImage {
  func headers(withSession session: URLSession = .shared) async throws -> [AnyHashable: Any] {
    var request = URLRequest(url: url)
    request.httpMethod = "HEAD"
    let (_, response) = try await session.data(for: request)

    guard let response = response as? HTTPURLResponse else {
      throw MissingError.needDefinition(response)
    }

    return response.allHeaderFields
  }
}

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
}
