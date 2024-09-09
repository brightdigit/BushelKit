//
// Binding.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation

  public import SwiftUI

  extension Binding {
    @MainActor
    public func map<T>(to get: @escaping @Sendable (Value) -> T, from set: @escaping @Sendable (T) -> Value) -> Binding<T> {
      .init {
        get(self.wrappedValue)
      } set: {
        self.wrappedValue = set($0)
      }
    }
  }
#endif
