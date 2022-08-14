//
// BushelApplication.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

import SwiftUI

public protocol BushelApplication: App {}

public extension BushelApplication {
  var body: some Scene {
    BushelScene()
  }
}
