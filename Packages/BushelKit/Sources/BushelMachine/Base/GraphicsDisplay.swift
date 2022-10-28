//
// GraphicsDisplay.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct GraphicsDisplay: Codable, Identifiable {
  public let id: UUID
  public init(id: UUID = .init(), widthInPixels: Int, heightInPixels: Int, pixelsPerInch: Int) {
    self.id = id
    self.widthInPixels = widthInPixels
    self.heightInPixels = heightInPixels
    self.pixelsPerInch = pixelsPerInch
  }

  public let widthInPixels: Int
  public let heightInPixels: Int
  public let pixelsPerInch: Int
}
