//
// CancelPageAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  private struct CancelPageKey: EnvironmentKey, Sendable {
    static let defaultValue: CancelPageAction = .default
  }

  public typealias CancelPageAction = PageAction

  public extension EnvironmentValues {
    var cancelPage: CancelPageAction {
      get { self[CancelPageKey.self] }
      set {
        self[CancelPageKey.self] = newValue
      }
    }
  }
#endif
