//
//  GraphicsDisplay.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

/// A struct representing a graphics display with various properties.
public struct GraphicsDisplay: Codable, Identifiable, Hashable, CustomStringConvertible, Sendable {
  /// A unique identifier for the graphics display.
  public let id: UUID

  /// The width of the display in pixels.
  public let widthInPixels: Int
  /// The height of the display in pixels.
  public let heightInPixels: Int
  /// The number of pixels per inch of the display.
  public let pixelsPerInch: Int

  /// A string representation of the graphics display's dimensions.
  public var description: String {
    "\(self.widthInPixels) x \(self.heightInPixels) (\(self.pixelsPerInch) ppi)"
  }

  /// Initializes a new `GraphicsDisplay` instance.
  /// - Parameters:
  ///   - id: The unique identifier for the graphics display. If not provided, a new UUID will be generated.
  ///   - widthInPixels: The width of the display in pixels.
  ///   - heightInPixels: The height of the display in pixels.
  ///   - pixelsPerInch: The number of pixels per inch of the display.
  public init(id: UUID = .init(), widthInPixels: Int, heightInPixels: Int, pixelsPerInch: Int) {
    self.id = id
    self.widthInPixels = widthInPixels
    self.heightInPixels = heightInPixels
    self.pixelsPerInch = pixelsPerInch
  }
}

extension GraphicsDisplay {
  /// The aspect ratio of the graphics display.
  public var aspectRatio: CGFloat {
    CGFloat(self.widthInPixels) / CGFloat(self.heightInPixels)
  }

  /// Returns a default `GraphicsDisplay` instance
  /// with a width of 1920 pixels, a height of 1080 pixels, and a pixels per inch of 80.
  /// - Returns: A default `GraphicsDisplay` instance.
  public static func `default`() -> GraphicsDisplay {
    .init(widthInPixels: 1_920, heightInPixels: 1_080, pixelsPerInch: 80)
  }
}
