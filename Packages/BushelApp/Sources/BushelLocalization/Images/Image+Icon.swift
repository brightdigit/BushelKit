//
// Image+Icon.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  extension Image {
    public init(icon: any Icon) {
      self.init(icon.name, bundle: .module)
    }
  }
#endif
