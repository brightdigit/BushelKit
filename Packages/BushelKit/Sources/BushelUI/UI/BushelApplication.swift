//
// BushelApplication.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
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
