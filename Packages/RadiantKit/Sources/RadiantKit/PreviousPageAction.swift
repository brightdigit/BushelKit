//
// PreviousPageAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  private struct PreviousPageKey: EnvironmentKey, Sendable {
    static let defaultValue: PreviousPageAction = .default
  }

  public typealias PreviousPageAction = PageAction

  public extension EnvironmentValues {
    var previousPage: PreviousPageAction {
      get { self[PreviousPageKey.self] }
      set {
        self[PreviousPageKey.self] = newValue
      }
    }
  }
#endif
