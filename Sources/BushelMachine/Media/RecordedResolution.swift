//
//  RecordedResolution.swift
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

/// A struct representing a recorded resolution.
public struct RecordedResolution: Sendable, Codable {
  /// The width of the recorded resolution.
  public let width: Int
  /// The height of the recorded resolution.
  public let height: Int

  /// Initializes a `RecordedResolution` with the specified width and height.
  /// - Parameters:
  ///   - width: The width of the recorded resolution.
  ///   - height: The height of the recorded resolution.
  public init(width: Int, height: Int) {
    self.width = width
    self.height = height
  }
}

extension RecordedResolution {
  /// Initializes a `RecordedResolution` from a `CGSize`.
  /// - Parameter cgSize: The `CGSize` to be converted to a `RecordedResolution`.
  public init(cgSize: CGSize) {
    self.init(width: .init(cgSize.width), height: .init(cgSize.height))
  }
}
