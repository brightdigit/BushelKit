//
// BushelApplication.swift
// Copyright (c) 2022 BrightDigit.
//

import SwiftUI

// periphery:ignore
public protocol BushelApplication: App {}

// periphery:ignore
public extension BushelApplication {
  var body: some Scene {
    BushelScene()
  }
}
