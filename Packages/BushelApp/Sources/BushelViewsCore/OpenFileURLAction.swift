//
// OpenFileURLAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore

  public import Foundation

  public import SwiftUI

  private struct OpenFileURLKey: EnvironmentKey, Sendable {
    typealias Value = OpenFileURLAction

    static let defaultValue: OpenFileURLAction = .default
  }

  public typealias OpenWindowURLAction = OpenWindowWithValueAction<URL>

  public typealias OpenFileURLAction = OpenWindowURLAction

  extension EnvironmentValues {
    public var openFileURL: OpenFileURLAction {
      get { self[OpenFileURLKey.self] }
      set { self[OpenFileURLKey.self] = newValue }
    }
  }

  extension Scene {
    public func openFileURL(
      _ closure: @escaping @Sendable @MainActor (URL, OpenWindowAction) -> Void
    ) -> some Scene {
      self.environment(\.openFileURL, .init(closure: closure))
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    public func openFileURL(
      _ closure: @Sendable @escaping @MainActor (URL, OpenWindowAction) -> Void
    ) -> some View {
      self.environment(\.openFileURL, .init(closure: closure))
    }
  }
#endif
