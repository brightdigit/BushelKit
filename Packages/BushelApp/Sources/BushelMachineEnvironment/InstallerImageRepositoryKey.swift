//
// InstallerImageRepositoryKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelMachine
  import Foundation
  import SwiftData
  import SwiftUI

  private struct DefaultInstallerImageRepository: InstallerImageRepository {
    struct NotImplmentedError: Swift.Error {
      static let instance = NotImplmentedError()
    }

    static let instance = DefaultInstallerImageRepository()

    func images(
      _: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> [any BushelMachine.InstallerImage] {
      assertionFailure("No Database Set.")
      throw NotImplmentedError.instance
    }

    func image(
      withID _: UUID,
      library _: BushelCore.LibraryIdentifier?,
      _: @escaping BushelCore.MetadataLabelProvider
    ) async throws -> (any BushelMachine.InstallerImage)? {
      assertionFailure("No Database Set.")
      throw NotImplmentedError.instance
    }

    func removeImage(
      _: any BushelMachine.InstallerImage
    ) async throws -> BushelMachine.RemoveImageFailure? {
      assertionFailure("No Database Set.")
      throw NotImplmentedError.instance
    }
  }

  private struct InstallerImageRepositoryKey: EnvironmentKey {
    static let defaultValue: Transformation<any Database, any InstallerImageRepository>
      = .default
  }

  public extension EnvironmentValues {
    var installerImageRepository: Transformation<any Database, any InstallerImageRepository> {
      get { self[InstallerImageRepositoryKey.self] }
      set { self[InstallerImageRepositoryKey.self] = newValue }
    }
  }

  private extension Transformation<any Database, any InstallerImageRepository> {
    static let `default`: Self = .init { _ in DefaultInstallerImageRepository.instance }
  }

  public extension Scene {
    func installerImageRepository(
      _ database: @Sendable @escaping (any Database) -> any InstallerImageRepository
    ) -> some Scene {
      self.environment(\.installerImageRepository, .init(database))
    }
  }
#endif
