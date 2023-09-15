//
// OpenWindowWithAction.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

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