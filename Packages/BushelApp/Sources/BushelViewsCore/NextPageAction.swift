//
// NextPageAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import Foundation

  public import SwiftUI

  @available(*, unavailable, message: "Use RadiantKit.")
  private struct NextPageKey: EnvironmentKey, Sendable {
    static let defaultValue: NextPageAction = .default
  }

  @available(*, unavailable, message: "Use RadiantKit.")
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

  extension EnvironmentValues {
    @available(*, unavailable, message: "Use RadiantKit.")
    public var nextPage: NextPageAction {
      get { self[NextPageKey.self] }
      set {
        self[NextPageKey.self] = newValue
      }
    }
  }
#endif
