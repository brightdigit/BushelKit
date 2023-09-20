//
// NewLibraryKey.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)

  import BushelCore
  import Foundation
  import SwiftUI

  public typealias NewLibraryAction = OpenWindowWithAction
  private struct NewLibraryKey: EnvironmentKey {
    static let defaultValue: NewLibraryAction = .default
  }

  public extension EnvironmentValues {
    var newLibrary: NewLibraryAction {
      get { self[NewLibraryKey.self] }
      set {
        self[NewLibraryKey.self] = newValue
      }
    }
  }

  public extension View {
    func newLibrary(
      _ closure: @escaping (OpenWindowAction) -> Void
    ) -> some View {
      environment(\.newLibrary, .init(closure: closure))
    }

    func newLibrary<FileType: InitializableFileTypeSpecification>(
      _: FileType.Type
    ) -> some View {
      newLibrary(NewFilePanel<FileType>().callAsFunction(with:))
    }
  }

  public extension Scene {
    func newLibrary(
      _ closure: @escaping (OpenWindowAction) -> Void
    ) -> some Scene {
      environment(\.newLibrary, .init(closure: closure))
    }

    func newLibrary<FileType: InitializableFileTypeSpecification>(
      _: FileType.Type
    ) -> some Scene {
      newLibrary(NewFilePanel<FileType>().callAsFunction(with:))
    }
  }
#endif
