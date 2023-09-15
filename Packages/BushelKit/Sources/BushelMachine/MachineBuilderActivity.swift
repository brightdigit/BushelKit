//
// MachineBuilderActivity.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MachineBuilderActivity: Identifiable {
  public let builder: MachineBuilder
  public var id: URL {
    builder.url
  }

  public init(builder: MachineBuilder) {
    self.builder = builder
  }
}