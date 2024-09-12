//
// LibrarySystemManagerKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  public import BushelLibrary
  import Foundation
  import SwiftData

  public import RadiantDocs

  public import SwiftUI

  private struct LibrarySystemManagerKey: EnvironmentKey {
    static let defaultValue: any LibrarySystemManaging =
      LibrarySystemManager(.init(), fileTypeBasedOnURL: { _ in nil })
  }

  extension EnvironmentValues {
    public var librarySystemManager: any LibrarySystemManaging {
      get { self[LibrarySystemManagerKey.self] }
      set { self[LibrarySystemManagerKey.self] = newValue }
    }
  }

  extension Scene {
    public func librarySystemManager(
      _ systemManager: any LibrarySystemManaging
    ) -> some Scene {
      self.environment(\.librarySystemManager, systemManager)
    }

    public func librarySystemManager(
      @LibrarySystemBuilder builder: () -> [any LibrarySystem],
      fileTypeBasedOnURL: @Sendable @escaping (URL) -> FileType?
    ) -> some Scene {
      self.librarySystemManager(
        LibrarySystemManager(
          builder(),
          fileTypeBasedOnURL: fileTypeBasedOnURL
        )
      )
    }
  }
#endif
