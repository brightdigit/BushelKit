//
// ValueTextBubble.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import Foundation

  public import SwiftUI

  public struct ValueTextBubble<
    ShapeStyleType: ShapeStyle,
    ValueType: Equatable,
    FormatStyleType: FormatStyle
  >: View where
    FormatStyleType.FormatInput == ValueType,
    FormatStyleType.FormatOutput == String {
    public let value: ValueType
    public let format: FormatStyleType
    public let backgroundStyle: ShapeStyleType
    public let cornerRadius: CGFloat

    public var body: some View {
      Text(value, format: format)
        .background {
          RoundedRectangle(cornerRadius: cornerRadius)
            .padding(-2)
            .padding(.horizontal, -4)
            .foregroundStyle(backgroundStyle)
        }
        .padding(.horizontal, 2)
    }

    public init(
      value: ValueType,
      format: FormatStyleType,
      backgroundStyle: ShapeStyleType,
      cornerRadius: CGFloat = 18
    ) {
      self.value = value
      self.format = format
      self.cornerRadius = cornerRadius
      self.backgroundStyle = backgroundStyle
    }

    public init(
      value: ValueType,
      format: FormatStyleType,
      backgroundColor: Color = Color.primary.opacity(0.25),
      cornerRadius: CGFloat = 18
    ) where ShapeStyleType == Color {
      self.value = value
      self.format = format
      self.cornerRadius = cornerRadius
      self.backgroundStyle = backgroundColor
    }

    public init(
      value: Int,
      format: IntegerFormatStyle<Int> = FormatStyleType.number,
      backgroundColor: Color = Color.primary.opacity(0.25),
      cornerRadius: CGFloat = 18
    ) where ValueType == Int, ShapeStyleType == Color, FormatStyleType == IntegerFormatStyle<Int> {
      self.value = value
      self.format = format
      self.cornerRadius = cornerRadius
      self.backgroundStyle = backgroundColor
    }
  }
#endif
