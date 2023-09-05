//
// MachineBuilderActivity.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MachineBuilderActivity: Identifiable {
  public init(builder: MachineBuilder) {
    self.builder = builder
  }

  public var id: URL {
    builder.url
  }

  public let builder: MachineBuilder
}
