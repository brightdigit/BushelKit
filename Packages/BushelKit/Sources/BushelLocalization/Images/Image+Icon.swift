//
// Image+Icon.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  public extension Image {
    init(icon: Icon) {
      self.init(icon.name, bundle: .module)
    }
  }
#endif
