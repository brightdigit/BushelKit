//
// NextPageAction.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  private struct NextPageKey: EnvironmentKey {
    static let defaultValue: NextPageAction = .default
  }

  public struct NextPageAction {
    static let `default`: NextPageAction = .init {
      assertionFailure()
    }

    let nextPageFunction: () -> Void
    internal init(_ nextPageFunction: @escaping () -> Void) {
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
