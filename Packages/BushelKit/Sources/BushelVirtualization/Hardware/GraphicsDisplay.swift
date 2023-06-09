//
// GraphicsDisplay.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct GraphicsDisplay: Codable, Identifiable, Hashable, CustomStringConvertible {
  public let id: UUID

  public let widthInPixels: Int
  public let heightInPixels: Int
  public let pixelsPerInch: Int

  public init(id: UUID = .init(), widthInPixels: Int, heightInPixels: Int, pixelsPerInch: Int) {
    self.id = id
    self.widthInPixels = widthInPixels
    self.heightInPixels = heightInPixels
    self.pixelsPerInch = pixelsPerInch
  }

  public var description: String {
    "\(widthInPixels) x \(heightInPixels) (\(pixelsPerInch) ppi)"
  }
}
