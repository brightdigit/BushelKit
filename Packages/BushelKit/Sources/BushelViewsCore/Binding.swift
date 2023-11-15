//
// Binding.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation

  import SwiftUI

  public extension Binding {
    func map<T>(to get: @escaping (Value) -> T, from set: @escaping (T) -> Value) -> Binding<T> {
      .init {
        get(self.wrappedValue)
      } set: {
        self.wrappedValue = set($0)
      }
    }
  }
#endif
