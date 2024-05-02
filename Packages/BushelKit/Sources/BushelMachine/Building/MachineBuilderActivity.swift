//
// MachineBuilderActivity.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct MachineBuilderActivity: Identifiable, Sendable {
  public let builder: any MachineBuilder
  public var id: URL {
    builder.url
  }

  public init(builder: any MachineBuilder) {
    self.builder = builder
  }
}
