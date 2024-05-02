//
// OpenFileURLAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  private struct OpenFileURLKey: EnvironmentKey, Sendable {
    typealias Value = OpenFileURLAction

    static let defaultValue: OpenFileURLAction = .default
  }

  public typealias OpenWindowURLAction = OpenWindowWithValueAction<URL>

  public typealias OpenFileURLAction = OpenWindowURLAction

  public extension EnvironmentValues {
    var openFileURL: OpenFileURLAction {
      get { self[OpenFileURLKey.self] }
      set { self[OpenFileURLKey.self] = newValue }
    }
  }

  public extension Scene {
    func openFileURL(
      _ closure: @escaping @Sendable (URL, OpenWindowAction) -> Void
    ) -> some Scene {
      self.environment(\.openFileURL, .init(closure: closure))
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  public extension View {
    func openFileURL(
      _ closure: @escaping @Sendable (URL, OpenWindowAction) -> Void
    ) -> some View {
      self.environment(\.openFileURL, .init(closure: closure))
    }
  }
#endif
