//
// InstallerImageRepositoryKey.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  private struct InstallerImageRepositoryKey: EnvironmentKey {
    static let defaultValue: Transformation<ModelContext, InstallerImageRepository> = .init {
      // swiftlint:disable:next force_cast
      $0 as! any InstallerImageRepository
    }
  }

  public extension EnvironmentValues {
    var installerImageRepository: Transformation<ModelContext, InstallerImageRepository> {
      get { self[InstallerImageRepositoryKey.self] }
      set { self[InstallerImageRepositoryKey.self] = newValue }
    }
  }

  public extension Scene {
    func installerImageRepository(
      _ database: @escaping (ModelContext) -> InstallerImageRepository
    ) -> some Scene {
      self.environment(\.installerImageRepository, .init(database))
    }
  }
#endif
