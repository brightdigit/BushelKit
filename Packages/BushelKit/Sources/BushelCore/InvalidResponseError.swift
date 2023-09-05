//
// InvalidResponseError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct InvalidResponseError: LocalizedError {
  public init(_ response: URLResponse, from url: URL) {
    self.response = response
    self.url = url
  }

  public let response: URLResponse
  public let url: URL
}
