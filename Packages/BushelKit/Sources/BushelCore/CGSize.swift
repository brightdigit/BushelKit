//
// CGSize.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension CGSize {
  @inlinable
  func resizing(
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
