//
// DatabaseKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftData
  import SwiftUI

  struct DefaultDatabase: Database {
    struct NotImplmentedError: Error {
      static let instance = NotImplmentedError()
    }

    static let instance = DefaultDatabase()

    func transaction(_: @escaping (ModelContext) throws -> Void) async throws {
      assertionFailure("No Database Set.")
      throw NotImplmentedError.instance
    }

    func delete(where _: Predicate<some PersistentModel>?) async throws {
      assertionFailure("No Database Set.")
      throw NotImplmentedError.instance
    }

    func fetch<T>(_: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
      assertionFailure("No Database Set.")
      throw NotImplmentedError.instance
    }

    func delete(_: some PersistentModel) async {
      assertionFailure("No Database Set.")
    }

    func insert(_: some PersistentModel) async {
      assertionFailure("No Database Set.")
    }

    func save() async throws {
      assertionFailure("No Database Set.")
      throw NotImplmentedError.instance
    }

    func contextMatchesModel(_: some PersistentModel) -> Bool {
      false
    }
  }

  private struct DatabaseKey: EnvironmentKey {
    static var defaultValue: any Database {
      DefaultDatabase.instance
    }
  }

  public extension EnvironmentValues {
    var database: any Database {
      get { self[DatabaseKey.self] }
      set { self[DatabaseKey.self] = newValue }
    }
  }

  public extension Scene {
    func database(
      _ database: any Database
    ) -> some Scene {
      self.environment(\.database, database)
    }
  }

  @available(*, deprecated, message: "This is a fix for a bug. Use Scene only eventually.")
  public extension View {
    func database(
      _ database: any Database
    ) -> some View {
      self.environment(\.database, database)
    }
  }
#endif
