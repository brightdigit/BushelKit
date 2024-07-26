//
// Binding.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import Foundation

  public import SwiftUI

  extension Binding {
    public func map<T>(to get: @escaping (Value) -> T, from set: @escaping (T) -> Value) -> Binding<T> {
      .init {
        get(self.wrappedValue)
      } set: {
        self.wrappedValue = set($0)
      }
    }
  }
#endif
