//
// WishListValue.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore
  import BushelEnvironmentCore
  import Foundation
  import SwiftData

  public import SwiftUI

  private struct WishListKey: EnvironmentKey {
    typealias Value = WishListValue
  }

  public struct WishListValue: DefaultableViewValue {
    public static let `default` = WishListValue()

    private init() {}
  }

  extension EnvironmentValues {
    public var wishList: WishListValue {
      get { self[WishListKey.self] }
      set { self[WishListKey.self] = newValue }
    }
  }

#endif
