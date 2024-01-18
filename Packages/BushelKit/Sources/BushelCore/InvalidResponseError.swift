//
// InvalidResponseError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct InvalidResponseError: LocalizedError {
  public let response: URLResponse
  public let url: URL

  public init(_ response: URLResponse, from url: URL) {
    self.response = response
    self.url = url
  }
}
