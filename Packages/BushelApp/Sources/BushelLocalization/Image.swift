//
// Image.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  extension Image {
    public static func resource(_ name: String) -> Image {
      Image(name, bundle: .module)
    }
  }
#endif
