//
// EnvironmentKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  public extension EnvironmentKey where Value: DefaultableViewValue {
    static var defaultValue: Value {
      Value.default
    }
  }
#endif
