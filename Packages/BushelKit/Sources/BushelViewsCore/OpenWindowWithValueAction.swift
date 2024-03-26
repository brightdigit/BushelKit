//
// OpenWindowWithValueAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  public struct OpenWindowWithValueAction<ValueType> {
    public static var `default`: Self {
      OpenWindowWithValueAction(closure: Self.defaultClosure(_:with:))
    }

    let closure: (ValueType, OpenWindowAction) -> Void
    public init(closure: @escaping (ValueType, OpenWindowAction) -> Void) {
      self.closure = closure
    }

    private static func defaultClosure(_: ValueType, with _: OpenWindowAction) {
      assertionFailure()
    }

    public func callAsFunction(_ value: ValueType, with openWidow: OpenWindowAction) {
      closure(value, openWidow)
    }
  }
#endif
