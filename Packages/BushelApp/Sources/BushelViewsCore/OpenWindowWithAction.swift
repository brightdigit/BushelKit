//
// OpenWindowWithAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  public import BushelCore

  public import Foundation

  public import SwiftUI

  public typealias OpenWindowWithAction = OpenWindowWithValueAction<Void>

  @MainActor
  extension OpenWindowWithAction {
    public init(closure: @escaping @Sendable @MainActor (OpenWindowAction) -> Void) {
      self.init { _, action in
        closure(action)
      }
    }

    @MainActor public func callAsFunction(with openWidow: OpenWindowAction) {
      closure((), openWidow)
    }
  }
#endif
