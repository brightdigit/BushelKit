//
// Color.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import SwiftUI

  extension Color {
    public enum Water {
      public static let s100 = Color(hex: "#EEF7FF")
      public static let s200 = Color(hex: "#E2F1FE")
      public static let s300 = Color(hex: "#D7EBFC")
      public static let s400 = Color(hex: "#CBE4FB")
      public static let s500 = Color(hex: "#BDDCF9")
      public static let s600 = Color(hex: "#B0D5F7")
      public static let s700 = Color(hex: "#A3CEF5")
      public static let s800 = Color(hex: "#96C6F2")
      public static let s900 = Color(hex: "#8AC0F2")
      public static let s950 = Color(hex: "#79B5EB")
      public static let s975 = Color(hex: "#0D5AA1")
    }

    public enum Apple {
      public static let s12 = Color(hex: "#FFD5D9")
      public static let s25 = Color(hex: "#FFB8BE")
      public static let s50 = Color(hex: "#FF9BA4")
      public static let s75 = Color(hex: "#FF8792")
      public static let s100 = Color(hex: "#FF7884")
      public static let s200 = Color(hex: "#FF6D7A")
      public static let s300 = Color(hex: "#FF6372")
      public static let s400 = Color(hex: "#FE5969")
      public static let s500 = Color(hex: "#FE4F60")
      public static let s600 = Color(hex: "#F34C5C")
      public static let s700 = Color(hex: "#E84857")
      public static let s800 = Color(hex: "#DE4553")
      public static let s900 = Color(hex: "#D44250")
    }

    public enum Sandy {
      public static let s100 = Color(hex: "#FFD3A6")
      public static let s200 = Color(hex: "#FFCE9B")
      public static let s300 = Color(hex: "#FFC891")
      public static let s400 = Color(hex: "#FFC286")
      public static let s500 = Color(hex: "#FFBD7B")
      public static let s600 = Color(hex: "#FCAF6E")
      public static let s700 = Color(hex: "#FAA762")
      public static let s800 = Color(hex: "#FAA157")
      public static let s900 = Color(hex: "#FA9C4E")
    }
  }

  extension Color {
    private init(hex: String) {
      let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      var int: UInt64 = 0
      Scanner(string: hex).scanHexInt64(&int)
      let alpha, red, green, blue: UInt64
      switch hex.count {
      case 3: // RGB (12-bit)
        (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
      case 6: // RGB (24-bit)
        (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8: // ARGB (32-bit)
        (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
      default:
        (alpha, red, green, blue) = (255, 0, 0, 0)
      }
      self.init(
        .sRGB,
        red: Double(red) / 255,
        green: Double(green) / 255,
        blue: Double(blue) / 255,
        opacity: Double(alpha) / 255
      )
    }
  }
#endif
