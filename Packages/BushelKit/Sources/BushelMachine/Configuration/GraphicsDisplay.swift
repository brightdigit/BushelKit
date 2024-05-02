//
// GraphicsDisplay.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct GraphicsDisplay: Codable, Identifiable, Hashable, CustomStringConvertible, Sendable {
  public let id: UUID

  public let widthInPixels: Int
  public let heightInPixels: Int
  public let pixelsPerInch: Int

  public var description: String {
    "\(widthInPixels) x \(heightInPixels) (\(pixelsPerInch) ppi)"
  }

  // swiftlint:disable:next function_default_parameter_at_end
  public init(id: UUID = .init(), widthInPixels: Int, heightInPixels: Int, pixelsPerInch: Int) {
    self.id = id
    self.widthInPixels = widthInPixels
    self.heightInPixels = heightInPixels
    self.pixelsPerInch = pixelsPerInch
  }
}

public extension GraphicsDisplay {
  var aspectRatio: CGFloat {
    CGFloat(self.widthInPixels) / CGFloat(self.heightInPixels)
  }

  static func `default`() -> GraphicsDisplay {
    .init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)
  }
}
