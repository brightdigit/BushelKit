//
// Image.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public extension Image {
    static func resource(_ name: String) -> Image {
      Image(name, bundle: .module)
    }
  }
#endif
