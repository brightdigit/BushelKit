//
// URL.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension URL {
  init(_ staticString: StaticString) {
    guard let url = URL(string: .init(describing: staticString)) else {
      fatalError("Invalid URL String")
    }
    self = url
  }
}
