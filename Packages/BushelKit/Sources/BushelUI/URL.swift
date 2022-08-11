//
// URL.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Foundation

extension URL {
  init(forHandle handle: WindowOpenHandle) {
    var components = Configuration.baseURLComponents
    components.path = handle.path
    guard let url = components.url else {
      preconditionFailure()
    }
    self = url
  }
}
