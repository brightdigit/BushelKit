//
// LibrarySystemManagerKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import Foundation
  import SwiftData
  import SwiftUI

  private struct LibrarySystemManagerKey: EnvironmentKey {
    static let defaultValue: any LibrarySystemManaging =
      LibrarySystemManager(.init(), fileTypeBasedOnURL: { _ in nil })
  }

  public extension EnvironmentValues {
    var librarySystemManager: any LibrarySystemManaging {
      get { self[LibrarySystemManagerKey.self] }
      set { self[LibrarySystemManagerKey.self] = newValue }
    }
  }

  public extension Scene {
    func librarySystemManager(
      _ systemManager: any LibrarySystemManaging
    ) -> some Scene {
      self.environment(\.librarySystemManager, systemManager)
    }

    func librarySystemManager(
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
