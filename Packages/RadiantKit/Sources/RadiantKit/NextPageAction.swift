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

  public struct PageAction: Sendable {
    static let `default`: PageAction = .init {
      assertionFailure()
    }

    let pageFunction: @Sendable @MainActor () -> Void
    internal init(_ pageFunction: @Sendable @MainActor @escaping () -> Void) {
      self.pageFunction = pageFunction
    }

    @MainActor
    public func callAsFunction() {
      pageFunction()
    }
  }

  public typealias NextPageAction = PageAction

  public extension EnvironmentValues {
    var nextPage: NextPageAction {
      get { self[NextPageKey.self] }
      set {
        self[NextPageKey.self] = newValue
      }
    }
  }
#endif
