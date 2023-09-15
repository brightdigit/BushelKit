//
// Image+Icon.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  extension Image {
    init(icon: Icon) {
      self.init(icon.name, bundle: .module)
    }
  }
#endif