//
// ImportRequest.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

internal enum ImportRequest {
  case remote(url: URL, metadata: ImageMetadata)
  case local(url: URL)

  var url: URL {
    switch self {
    case .remote(url: let url, metadata: _):
      url

    case let .local(url: url):
      url
    }
  }

  var metadata: ImageMetadata? {
    switch self {
    case .remote(url: _, metadata: let metadata):
      metadata

    default:
      nil
    }
  }

  #if !os(Linux)
    // swiftlint:disable:next discouraged_optional_boolean
    func startAccessingSecurityScopedResource() -> Bool? {
      switch self {
      case let .local(url: url):
        url.startAccessingSecurityScopedResource()

      default:
        nil
      }
    }

    @discardableResult
    func stopAccessingSecurityScopedResource() -> Void? {
      switch self {
      case let .local(url: url):
        url.stopAccessingSecurityScopedResource()

      default:
        nil
      }
    }
  #endif
}
