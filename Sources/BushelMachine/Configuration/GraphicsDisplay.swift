//
//  GraphicsDisplay.swift
//  Sublimation
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

public struct GraphicsDisplay: Codable, Identifiable, Hashable, CustomStringConvertible, Sendable {
  public let id: UUID

  public let widthInPixels: Int
  public let heightInPixels: Int
  public let pixelsPerInch: Int

  public var description: String { "\(widthInPixels) x \(heightInPixels) (\(pixelsPerInch) ppi)" }

  public init(id: UUID = .init(), widthInPixels: Int, heightInPixels: Int, pixelsPerInch: Int) {
    self.id = id
    self.widthInPixels = widthInPixels
    self.heightInPixels = heightInPixels
    self.pixelsPerInch = pixelsPerInch
  }
}

extension GraphicsDisplay {
  public var aspectRatio: CGFloat { CGFloat(widthInPixels) / CGFloat(heightInPixels) }

  public static func `default`() -> GraphicsDisplay {
    .init(widthInPixels: 1_920, heightInPixels: 1_080, pixelsPerInch: 80)
  }
}
