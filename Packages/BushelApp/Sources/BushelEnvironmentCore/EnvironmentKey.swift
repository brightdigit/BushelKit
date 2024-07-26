//
// EnvironmentKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore
  import Foundation

  public import SwiftUI

  extension EnvironmentKey where Value: DefaultableViewValue {
    public static var defaultValue: Value {
      Value.default
    }
  }
#endif
