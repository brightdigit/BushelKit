//
// OpenLibraryKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)

  import Foundation

  public import SwiftUI

  public import RadiantDocs

  public typealias OpenLibraryAction = OpenWindowWithAction

  private struct OpenLibraryKey: EnvironmentKey {
    static let defaultValue: OpenLibraryAction = .default
  }

  extension EnvironmentValues {
    public var openLibrary: OpenLibraryAction {
      get { self[OpenLibraryKey.self] }
      set {
        self[OpenLibraryKey.self] = newValue
      }
    }
  }

  extension Scene {
    @MainActor
    public func openLibrary(
      _ closure: @escaping @Sendable @MainActor (OpenWindowAction) -> Void
    ) -> some Scene {
      environment(\.openLibrary, .init(closure: closure))
    }

    @MainActor
    public func openLibrary<FileType: FileTypeSpecification>(
      _: FileType.Type
    ) -> some Scene {
      openLibrary { action in
        OpenFilePanel<FileType>().callAsFunction(with: action)
      }
    }
  }

#endif
