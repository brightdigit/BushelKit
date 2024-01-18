//
// ImportRequest.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

enum ImportRequest {
  case remote(url: URL, metadata: ImageMetadata)
  case local(url: URL)

  var url: URL {
    switch self {
    case .remote(url: let url, metadata: _):
      return url

    case let .local(url: url):
      return url
    }
  }

  var metadata: ImageMetadata? {
    switch self {
    case .remote(url: _, metadata: let metadata):
      return metadata

    default:
      return nil
    }
  }

  #if !os(Linux)
    // swiftlint:disable:next discouraged_optional_boolean
    func startAccessingSecurityScopedResource() -> Bool? {
      switch self {
      case let .local(url: url):
        return url.startAccessingSecurityScopedResource()

      default:
        return nil
      }
    }

    @discardableResult
    func stopAccessingSecurityScopedResource() -> Void? {
      switch self {
      case let .local(url: url):
        return url.stopAccessingSecurityScopedResource()

      default:
        return nil
      }
    }
  #endif
}
