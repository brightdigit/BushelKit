//
// URL.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
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
}
