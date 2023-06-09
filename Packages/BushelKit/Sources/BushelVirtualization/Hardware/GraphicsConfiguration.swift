//
// GraphicsConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct GraphicsConfiguration: Codable, Identifiable {
  public let id: UUID
  public let displays: [GraphicsDisplay]
  public init(id: UUID = .init(), displays: [GraphicsDisplay]) {
    self.id = id
    self.displays = displays
  }
}
