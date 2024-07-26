//
// NewLibraryKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)

  public import BushelCore

  public import Foundation

  public import SwiftUI

  public typealias NewLibraryAction = OpenWindowWithAction
  private struct NewLibraryKey: EnvironmentKey, Sendable {
    static let defaultValue: NewLibraryAction = .default
  }

  extension EnvironmentValues {
    public var newLibrary: NewLibraryAction {
      get { self[NewLibraryKey.self] }
      set {
        self[NewLibraryKey.self] = newValue
      }
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    @MainActor
    public func newLibrary(
      _ closure: @escaping @Sendable @MainActor (OpenWindowAction) -> Void
    ) -> some View {
      environment(\.newLibrary, .init(closure: closure))
    }

    @MainActor
    public func newLibrary<FileType: InitializableFileTypeSpecification>(
      _: FileType.Type
    ) -> some View {
      newLibrary {
        NewFilePanel<FileType>()(with: $0)
      }
    }
  }

  extension Scene {
    @MainActor
    public func newLibrary(
      _ closure: @escaping @Sendable @MainActor (OpenWindowAction) -> Void
    ) -> some Scene {
      environment(\.newLibrary, .init(closure: closure))
    }

    @MainActor
    public func newLibrary<FileType: InitializableFileTypeSpecification>(
      _: FileType.Type
    ) -> some Scene {
      newLibrary {
        NewFilePanel<FileType>()(with: $0)
      }
    }
  }
#endif
