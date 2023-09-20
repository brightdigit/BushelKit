//
// AllowedOpenFileTypesKey.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  import BushelCore
  import Foundation
  import SwiftUI
  import UniformTypeIdentifiers

  private struct AllowedOpenFileTypesKey: EnvironmentKey {
    typealias Value = [FileType]
    static let defaultValue = [FileType]()
  }

  public extension EnvironmentValues {
    var allowedOpenFileTypes: [FileType] {
      get { self[AllowedOpenFileTypesKey.self] }
      set { self[AllowedOpenFileTypesKey.self] = newValue }
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  public extension View {
    func allowedOpenFileTypes(
      _ fileTypes: [FileType]
    ) -> some View {
      self.environment(\.allowedOpenFileTypes, fileTypes)
    }
  }

  public extension Scene {
    func allowedOpenFileTypes(
      _ fileTypes: [FileType]
    ) -> some Scene {
      self.environment(\.allowedOpenFileTypes, fileTypes)
    }
  }

#endif
