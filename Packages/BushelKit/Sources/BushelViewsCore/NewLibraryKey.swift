//
// NewLibraryKey.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  private struct NewLibraryKey: EnvironmentKey {
    static let defaultValue: NewLibraryAction = .default
  }

  public typealias NewLibraryAction = OpenWindowWithAction

  public extension EnvironmentValues {
    var newLibrary: NewLibraryAction {
      get { self[NewLibraryKey.self] }
      set {
        self[NewLibraryKey.self] = newValue
      }
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
