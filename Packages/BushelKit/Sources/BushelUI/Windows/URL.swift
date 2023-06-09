//
// URL.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

extension URL {
  init<HandleType: WindowOpenHandle>(forHandle handle: HandleType) {
    var components = Configuration.baseURLComponents
    components.host = HandleType.host(of: handle)
    if let path = HandleType.path(of: handle) {
      components.path = path
    }
    guard let url = components.url else {
      preconditionFailure()
    }
    self = url
  }

  init(_ string: StaticString) {
    guard let url = URL(string: "\(string)") else {
      preconditionFailure("Invalid static URL string: \(string)")
    }

    self = url
  }
}
