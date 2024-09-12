//
// EnvironmentKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation

  public import SwiftUI

  public import RadiantKit

  extension EnvironmentKey where Value: DefaultableViewValue {
    public static var defaultValue: Value {
      Value.default
    }
  }
#endif
