//
// AllowedOpenFileTypesKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit

  public import BushelCore

  public import Foundation

  public import SwiftUI

  public import UniformTypeIdentifiers

  private struct AllowedOpenFileTypesKey: EnvironmentKey {
    typealias Value = [FileType]
    static let defaultValue = [FileType]()
  }

  extension EnvironmentValues {
    public var allowedOpenFileTypes: [FileType] {
      get { self[AllowedOpenFileTypesKey.self] }
      set { self[AllowedOpenFileTypesKey.self] = newValue }
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    public func allowedOpenFileTypes(
      _ fileTypes: [FileType]
    ) -> some View {
      self.environment(\.allowedOpenFileTypes, fileTypes)
    }
  }

  extension Scene {
    public func allowedOpenFileTypes(
      _ fileTypes: [FileType]
    ) -> some Scene {
      self.environment(\.allowedOpenFileTypes, fileTypes)
    }
  }

#endif
