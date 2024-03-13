//
// NextPageAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  private struct NextPageKey: EnvironmentKey, Sendable {
    static let defaultValue: NextPageAction = .default
  }

  public struct NextPageAction: Sendable {
    static let `default`: NextPageAction = .init {
      assertionFailure()
    }

    let nextPageFunction: @Sendable () -> Void
    internal init(_ nextPageFunction: @Sendable @escaping () -> Void) {
      self.nextPageFunction = nextPageFunction
    }

    public func callAsFunction() {
      nextPageFunction()
    }
  }

  public extension EnvironmentValues {
    var nextPage: NextPageAction {
      get { self[NextPageKey.self] }
      set {
        self[NextPageKey.self] = newValue
      }
    }
  }
#endif
