//
//  CGSize.swift
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

extension CGSize {
  /// Resizes the `CGSize` to maintain the given aspect ratio, while ensuring a minimum width.
  ///
  /// - Parameters:
  ///   - aspectRatio: The desired aspect ratio of the resized size.
  ///   - minimumWidth: The minimum width of the resized size.
  ///   - additionalHeight: Additional height to be added to the resized size.
  ///
  /// - Returns: The resized `CGSize` that maintains the given aspect ratio and has a minimum width.
  @inlinable
  public func resizing(
    toAspectRatio aspectRatio: CGFloat,
    minimumWidth: CGFloat,
    withAdditionalHeight additionalHeight: CGFloat
  ) -> CGSize {
    let remainingHeight = max(self.height - additionalHeight, 0)
    let calculatedWidth = remainingHeight * aspectRatio
    if calculatedWidth < minimumWidth {
      return .init(width: minimumWidth, height: minimumWidth / aspectRatio + additionalHeight)
    } else {
      return .init(width: calculatedWidth, height: remainingHeight + additionalHeight)
    }
  }
}
