//
// OpenWindowWithValueAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  public struct OpenWindowWithValueAction<ValueType: Sendable>: Sendable {
    public static var `default`: Self {
      .init { value, action in
        Self.defaultClosure(value, with: action)
      }
    }

    let closure: @Sendable @MainActor (ValueType, OpenWindowAction) -> Void
    public init(closure: @escaping @MainActor @Sendable (ValueType, OpenWindowAction) -> Void) {
      self.closure = closure
    }

    private static func defaultClosure(_: ValueType, with _: OpenWindowAction) {
      assertionFailure()
    }

    @MainActor
    public func callAsFunction(_ value: ValueType, with openWidow: OpenWindowAction) {
      closure(value, openWidow)
    }
  }
#endif
