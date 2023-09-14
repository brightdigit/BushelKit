//
// MissingAttributeError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MissingAttributeError: LocalizedError {
  public enum HeaderName: String {
    case contentLength = "Content-Length"
    case lastModified = "Last-Modified"
  }

  public let attributeKey: FileAttributeKey
  public let url: URL
  public let headers: [AnyHashable: Any]?

  public init(_ headerName: HeaderName, from url: URL, headers: [AnyHashable: Any]? = nil) {
    self.attributeKey = .init(headerName: headerName)
    self.url = url
    self.headers = headers
  }

  public init(_ attributeKey: FileAttributeKey, from url: URL, headers: [AnyHashable: Any]? = nil) {
    self.attributeKey = attributeKey
    self.url = url
    self.headers = headers
  }
}

extension FileAttributeKey {
  init(headerName: MissingAttributeError.HeaderName) {
    switch headerName {
    case .contentLength:
      self = .size

    case .lastModified:
      self = .modificationDate
    }
  }
}
