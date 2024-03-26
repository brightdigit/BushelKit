//
// GraphicsConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct GraphicsConfiguration: Codable, Identifiable {
  public let id: UUID
  public let displays: [GraphicsDisplay]
  // swiftlint:disable:next function_default_parameter_at_end
  public init(id: UUID = .init(), displays: [GraphicsDisplay]) {
    self.id = id
    self.displays = displays
  }
}

public extension GraphicsConfiguration {
  static func `default`() -> GraphicsConfiguration {
    .init(displays: [.default()])
  }
}
