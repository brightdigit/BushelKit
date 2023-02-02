//
// BushelApplication.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  // periphery:ignore
  public protocol BushelApplication: App {}

  // periphery:ignore
  public extension BushelApplication {
    var body: some Scene {
      BushelScene()
    }
  }
#endif
