//
// OpenWindowWithAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  public typealias OpenWindowWithAction = OpenWindowWithValueAction<Void>

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
