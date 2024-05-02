//
// OpenLibraryKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)

  import BushelCore
  import Foundation
  import SwiftUI

  public typealias OpenLibraryAction = OpenWindowWithAction

  private struct OpenLibraryKey: EnvironmentKey {
    static let defaultValue: OpenLibraryAction = .default
  }

  public extension EnvironmentValues {
    var openLibrary: OpenLibraryAction {
      get { self[OpenLibraryKey.self] }
      set {
        self[OpenLibraryKey.self] = newValue
      }
    }
  }

  public extension Scene {
    func openLibrary(
      _ closure: @escaping @MainActor (OpenWindowAction) -> Void
    ) -> some Scene {
      environment(\.openLibrary, .init(closure: closure))
    }

    func openLibrary<FileType: FileTypeSpecification>(
      _: FileType.Type
    ) -> some Scene {
      openLibrary(OpenFilePanel<FileType>().callAsFunction(with:))
    }
  }

#endif
