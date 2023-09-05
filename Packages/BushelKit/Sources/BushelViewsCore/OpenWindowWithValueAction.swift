//
// OpenWindowWithValueAction.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  public struct OpenWindowWithValueAction<ValueType> {
    public init(closure: @escaping (ValueType, OpenWindowAction) -> Void) {
      self.closure = closure
    }

    let closure: (ValueType, OpenWindowAction) -> Void
    private static func defaultClosure(_: ValueType, with _: OpenWindowAction) {
      assertionFailure()
    }

    public static var `default`: Self {
      OpenWindowWithValueAction(closure: Self.defaultClosure(_:with:))
    }

    public func callAsFunction(_ value: ValueType, with openWidow: OpenWindowAction) {
      closure(value, openWidow)
    }
  }

  public typealias OpenWindowWithAction = OpenWindowWithValueAction<Void>

  public extension OpenWindowWithAction {
    init(closure: @escaping (OpenWindowAction) -> Void) {
      self.init { _, action in
        closure(action)
      }
    }

    func callAsFunction(with openWidow: OpenWindowAction) {
      closure((), openWidow)
    }
  }
#endif
