//
// OpenFileURL.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  private struct OpenFileURLKey: EnvironmentKey {
    typealias Value = OpenFileURL

    static let defaultValue: OpenFileURL = .default
  }

  public typealias OpenWindowURLAction = OpenWindowWithValueAction<URL>

  public typealias OpenFileURL = OpenWindowURLAction

  public extension EnvironmentValues {
    var openFileURL: OpenFileURL {
      get { self[OpenFileURLKey.self] }
      set { self[OpenFileURLKey.self] = newValue }
    }
  }

  public extension Scene {
    func openFileURL(
      _ closure: @escaping (URL, OpenWindowAction) -> Void
    ) -> some Scene {
      self.environment(\.openFileURL, .init(closure: closure))
    }
  }
#endif
